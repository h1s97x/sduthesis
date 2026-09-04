# 项目运行方式

> [返回首页](./README.md) | [上一节：依赖关系](./dependencies.md) | [下一节：测试体系](./testing.md)

---

## 环境要求

- **TeX Live** 2020 及以上版本（推荐 2024+）
- 或 **MacTeX** (macOS)
- 或 **Overleaf / TeXPage** 在线编辑

---

## 用户编译流程

### 方式一：使用 `just`（推荐）

```bash
just build        # 编译 PDF（xelatex ×3 + biber）
just clean        # 清理辅助文件
just distclean    # 清理辅助文件和 PDF
just view         # 编译并打开 PDF（自动检测系统）
```

### 方式二：使用 `latexmk`（Overleaf 同款流程）

```bash
latexmk -xelatex main.tex
```

仓库根目录的 [latexmkrc](file:///workspace/latexmkrc) 配置确保 XeLaTeX + biber 流程自动收敛：

```perl
$pdf_mode = 5;            # 5 = xelatex
$bibtex_use = 2;          # 2 = 使用 biber（biblatex 后端）
$max_repeat = 6;          # 重跑上限（交叉引用 + 目录 + 参考文献收敛）
$bibtex_fudge = 1;        # 防止 biber 死循环
```

### 方式三：手动四次编译

```bash
xelatex -synctex=1 -interaction=nonstopmode -halt-on-error main.tex   # 1. 生成 .aux
biber main                                                            # 2. 处理参考文献
xelatex -synctex=1 -interaction=nonstopmode -halt-on-error main.tex  # 3. 嵌入引用
xelatex -synctex=1 -interaction=nonstopmode -halt-on-error main.tex  # 4. 解析交叉引用
```

**为什么需要四次编译**：
1. **xelatex** — 生成 `.aux` 文件，记录引用信息
2. **biber** — 读取 `.bcf`，处理 `.bib`，生成 `.bbl`
3. **xelatex** — 读取 `.bbl`，写入引用到 `.aux`
4. **xelatex** — 解析交叉引用，生成最终 PDF

---

## 用户配置流程

1. 修改 [sdusetup.tex](file:///workspace/sdusetup.tex) 中的 `\SDUSetup{}`（推荐使用 `info`/`option` 嵌套分组写法；也可按旧版把所有键平铺在顶层）：

```latex
\SDUSetup{
  module = {undergraduate},            % 模块选择，支持逗号分隔多模块
  info = {                             % 论文信息组
    title      = {你的论文标题},
    author     = {你的姓名},
    studentId  = {你的学号},
    school     = {你的学院},
    major      = {你的专业},
    supervisor = {指导教师},
    year       = {2025},
    month      = {6},
    % master/doctor 模块额外支持：
    % degree, committeeChair, committeeMembers, defenseDate, defensePlace
  },
  option = { lineSpread = 1.5 },       % 样式参数组（行距、页边距）
}
```

2. 编辑论文内容：

| 目录 | 内容 |
|------|------|
| `data/frontmatter/abstract.tex` | 中英文摘要 |
| `data/chapters/chapterN.tex` | 正文章节 |
| `data/ref/references.bib` | 参考文献 |
| `data/frontmatter/acknowledgement.tex` | 致谢 |
| `data/frontmatter/appendix.tex` | 附录 |
| `figures/` | 图片资源 |

---

## 在线编辑（Overleaf / TeXPage）

仓库根目录即为完整的在线编译模板：

- **Overleaf**：点击 README 顶部 "Open in Overleaf" 徽章（git 导入），或上传 `sduthesis-overleaf.zip`（由 `scripts/build-overleaf.sh` 生成）
- **TeXPage**：新建项目 → 上传仓库 zip

导入后务必设置：

| 设置项 | 值 |
|---|---|
| Compiler | **XeLaTeX** |
| Main document | `main.tex` |

---

## 开发者命令

完整的 [justfile](file:///workspace/justfile) 命令清单：

| 命令 | 作用 |
|------|------|
| `just` / `just build` | 编译 PDF（xelatex ×3 + biber） |
| `just test` | 编译 + 运行 `tests/test-compile.py` |
| `just lint` | chktex 代码检查（与 CI 一致） |
| `just gen` | 从 DTX 生成 `sduthesis.cls` |
| `just doc` | 编译开发者文档 `sduthesis-doc.pdf` |
| `just tds` | 构建 TDS 包（CTAN 发布格式） |
| `just ctan` | 构建 CTAN 发布包 |
| `just clean` | 清理辅助文件 |
| `just distclean` | 清理辅助文件和 PDF |
| `just view` | 编译并打开 PDF |
| `just help` | 显示帮助 |

### 关键开发命令详解

**从 DTX 重新生成 cls**（修改 `src/sduthesis.dtx` 后必须执行）：

```bash
just gen
# 等价于：
cd src && xelatex sduthesis.ins && cp sduthesis.cls ../sduthesis.cls
```

> 注意：`just gen` 会先 `rm -f src/sduthesis.cls`，避免 docstrip 交互式询问覆盖导致 CI 挂起。

**编译开发者文档**（`sduthesis-doc.pdf`，由 DTX 中的文档注释生成）：

```bash
just doc
# 等价于：
cd src && xelatex sduthesis.dtx && xelatex sduthesis.dtx && cp sduthesis.pdf ../sduthesis-doc.pdf
```

---

## 打包发布命令

| 脚本 | 产物 | 用途 |
|------|------|------|
| `just tds` | `sduthesis.tds.zip` | TDS 格式包（可 `tlmgr install`） |
| `just ctan` | `sduthesis-ctan.zip` | CTAN 标准发布包 |
| `bash scripts/build-ctan.sh` | `sduthesis-ctan.zip` | CTAN 提交包（补纯文本 README + 自检） |
| `bash scripts/build-overleaf.sh` | `sduthesis-overleaf.zip` | Overleaf/TeXPage 在线模板包（含编译自检） |
