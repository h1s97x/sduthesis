# CI 排障记录

本文档记录了 SDUThesis 项目 CI 从反复失败到最终成功的完整过程，供未来排障参考。

---

## 问题总览

| 阶段 | 错误现象 | 根因 | 修复 | 耗时 |
|------|----------|------|------|------|
| 1 | `.sty not found`（缺宏包） | tl_packages 手动列举不全 | 改用 collection 整组安装 | 多轮 |
| 2 | `The font "TeX Gyre Termes" cannot be found` | OTF 字体文件不在 XeTeX 搜索路径 | 符号链接 TEXMFDIST/fonts → ~/.fonts | 3 轮 |
| 3 | `Undefined control sequence \sdu` | LaTeX3 函数在 ExplSyntaxOff 区域调用 | 移入 ExplSyntaxOn 区域 | 1 轮 |

---

## 问题 1：反复缺少 TeX 宏包

### 现象

CI 编译时报 `xstring.sty not found`、`float.sty not found`、`tocloft.sty not found` 等。每次补一个包，下次又缺另一个。

### 错误思路（踩坑）

逐个手动往 `.github/tl_packages` 加包名：

```
# 第一轮：缺 float
+ float

# 第二轮：缺 tocloft  
+ tocloft

# 第三轮：缺 xstring
+ xstring

# ……无限循环
```

### 根因

手动列举宏包只能覆盖**直接依赖**，无法覆盖**传递依赖**。比如 `biblatex-gb7714-2015` 依赖 `xstring`，但 tl_packages 里没写 `xstring`。而且 TeX Live 的包依赖关系复杂，不可能手动穷举。

### 正确修复

安装完整的 collection，不再手动逐个列举：

```
# .github/tl_packages
scheme-minimal
collection-latex
collection-xetex
collection-latexrecommended
collection-latexextra
collection-fontsrecommended
collection-mathscience
collection-langchinese

# 仅列出 collection 无法覆盖的独立包
ctex
biber
biblatex
biblatex-gb7714-2015
latexmk
```

### 教训

> **永远不要手动列举宏包依赖**。用 collection 整组安装，代价是多 1-2 分钟安装时间，换来的是可靠性。除非 CI 安装时间成为瓶颈，否则不值得为节省时间而手动管理依赖。

---

## 问题 2：XeTeX 找不到字体

### 现象

```
! Package fontspec Error:
(fontspec)    The font "TeX Gyre Termes" cannot be found
```

依次尝试了三种英文字体，全部失败：
1. `TeX Gyre Termes` → not found
2. `Latin Modern Roman` → not found  
3. 最终连 `FandolSong`（中文字体）也 not found

### 错误思路（踩坑）

**第一轮**：以为没装字体包，加 `tex-gyre` 和 `tex-gyre-math` 到 tl_packages → 日志显示 `package already present`，但字体仍找不到。

**第二轮**：以为字体名拼写错误，换用 `Latin Modern Roman` → 同样失败。

**第三轮**：以为 `setup-texlive-action` 不支持 OTF 字体，改用 LaTeX 默认字体（不指定任何字体名）→ FandolSong 也找不到，说明问题不在字体名。

### 根因

`TeX-Live/setup-texlive-action` 安装了字体文件（.otf/.ttf）到 `TEXMFDIST/fonts/` 目录下，但 **XeTeX 的 fontspec 通过系统字体路径（`fc-list`）查找字体**，而不是通过 kpathsea 查找。setup-texlive-action 的安装目录不在系统的 fontconfig 搜索路径中。

所以虽然字体文件存在（`tlmgr info tex-gyre` 显示已安装），fontspec 就是找不到。

### 正确修复

参考 BIThesis 的 CI，将 TeX Live 的字体目录符号链接到 `~/.fonts/`：

```yaml
# .github/workflows/build.yml
- name: Link fonts for XeTeX
  run: |
    mkdir -p ~/.fonts
    ln -s $(kpsewhich -var-value=TEXMFDIST)/fonts/ ~/.fonts/texmf-dist-fonts
```

这是 `setup-texlive-action` 的**已知限制**，不是我们的模板问题。BIThesis 也遇到了同样的问题并采用了相同的解决方案。

### 教训

> **使用 setup-texlive-action 时，必须手动链接字体目录**。这不是可选步骤，是必须步骤。没有这个链接，任何 fontspec 的 `\setmainfont`/`\setsansfont`/`\setmonofont` 都会失败，包括 ctex 默认的 Fandol 字体。

---

## 问题 3：LaTeX3 命名空间错误

### 现象

```
! Undefined control sequence.
\__hook begindocument ...ngti  \ExplSyntaxOn \sdu 
                                                  _load_module: \ExplSyntaxO...
```

注意 `\sdu` 和 `_load_module:` 被换行截断。

### 错误思路（踩坑）

在 `\ExplSyntaxOff` 之后用 `\AtBeginDocument` 包裹 LaTeX3 代码：

```latex
% 错误写法
\ExplSyntaxOff
% ... 其他代码 ...

\AtBeginDocument{\ExplSyntaxOn \sdu_load_module: \ExplSyntaxOff}
```

### 根因

LaTeX3 的函数名中 `_` 和 `:` 在 `\ExplSyntaxOff` 区域是特殊字符。虽然理论上 `\ExplSyntaxOn` 可以临时切换命名空间，但在 `\AddToHook` 或 `\AtBeginDocument` 的参数中，**TeX 在解析参数时就已经把 `_` 当成下标符号处理了**，导致命令名被截断。

### 正确修复

将 Hook 注册移到 `\ExplSyntaxOn` 区域内：

```latex
\ExplSyntaxOn
  % ... 其他 LaTeX3 代码 ...

  \AddToHook{begindocument}{\sdu_load_module: \UseHook{sduthesis/after-setup}}
\ExplSyntaxOff
```

### 教训

> **所有 LaTeX3 函数调用必须在 `\ExplSyntaxOn` 区域内**。即使在 `\AtBeginDocument` 或 `\AddToHook` 的延迟执行代码中，函数名的**解析**发生在定义时，此时必须处于 expl3 模式。如果必须在文档级代码中调用 LaTeX3 函数，应该用 `\cs_set_eq:NN` 创建一个文档级别名。

---

## CI 配置检查清单

新建项目或修改 CI 时，逐项检查：

- [ ] **tl_packages 使用 collection 整组安装**，不手动列举宏包
- [ ] **字体目录已符号链接**：`ln -s $(kpsewhich -var-value=TEXMFDIST)/fonts/ ~/.fonts/texmf-dist-fonts`
- [ ] **LaTeX3 函数在 ExplSyntaxOn 区域内调用**
- [ ] **字体名称与 TeX Live 实际安装的字体一致**（用 `fc-list :lang=zh` 验证）
- [ ] **TEXINPUTS 包含所有自定义目录**（如 `modules/`）
- [ ] **编译链完整**：xelatex → biber → xelatex × 2

---

## 参考

- [setup-texlive-action 限制说明](https://github.com/TeX-Live/setup-texlive-action)
- [BIThesis CI 配置](https://github.com/BITNP/BIThesis) — 字体符号链接方案的来源
- [LaTeX3 编程接口](https://www.latex-project.org/help/documentation/) — expl3 命名空间规则
