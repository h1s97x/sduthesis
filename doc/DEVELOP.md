# SDUThesis 开发指南

本文档面向贡献者和维护者，说明如何修改和扩展 SDUThesis 模板。

## 项目架构

```
sduthesis/
├── sduthesis.cls                    # 内核引擎（SDUSetup + Hook + 基础排版）
├── modules/
│   └── sduthesis-undergraduate.sty  # 本科论文模块
├── sdusetup.tex                     # 用户配置
├── main.tex                         # 用户入口
├── data/                            # 用户内容
├── logos/                           # 校徽校名图片
└── .github/                         # CI/CD
```

**核心设计原则**：内核不包含任何特定类型论文的排版逻辑，只提供基础设施。所有论文类型特定的格式通过模块注入。

---

## 如何添加新的 SDUSetup 键

以添加 `abstractCn` 键为例，完整流程分四步：

### 第 1 步：声明变量（存储层）

在 `sduthesis.cls` 的 `\ExplSyntaxOn` 区域内，找到"存储层"部分：

```latex
% ==================== 存储层：变量声明 ====================
\tl_new:N \l__sdu_abstract_cn_tl    % 新增
```

命名规范：`\l__sdu_<键名>_tl`（token list）或 `\l__sdu_<键名>_dim`（dimension）。

### 第 2 步：注册键（定义层）

在"定义层"的 `\keys_define:nn { sdu }` 中添加：

```latex
\keys_define:nn { sdu }
{
  % ...已有键...
  abstractCn   .tl_set:N = \l__sdu_abstract_cn_tl,    % 新增
  abstractCn   .initial:n = { },                       % 可选：默认值
}
```

### 第 3 步：导出 Getter（导出层）

在"导出层"添加：

```latex
\NewDocumentCommand \GetAbstractCn { } { \l__sdu_abstract_cn_tl }
```

### 第 4 步：在模块中使用

模块中通过 Getter 获取值：

```latex
% modules/sduthesis-undergraduate.sty
\renewenvironment{cnabstract}{%
  \GetAbstractCn% 使用 Getter
}{}
```

用户在 `sdusetup.tex` 中设置：

```latex
\SDUSetup{
  abstractCn = {本文研究了……},
}
```

---

## 如何创建新模块

以创建硕士论文模块为例：

### 第 1 步：创建模块文件

```
modules/sduthesis-master.sty
```

### 第 2 步：基本结构

```latex
\ProvidesPackage{sduthesis-master}[YYYY/MM/DD vX.Y.Z SDUThesis master module]

% ============================================================
% 硕士论文模块
% 通过 \SDUSetup{module=master} 加载
% ============================================================

% 1. 覆盖封面
\renewcommand{\makecoverpage}{
  % 硕士论文封面排版逻辑
}

% 2. 覆盖摘要环境
\renewenvironment{cnabstract}[1][]{%
  % 硕士论文摘要格式
}{}

% 3. 通过 Hook 注入硕士特有内容
\AddToHook{sduthesis/frontmatter/begin}{%
  % 独创声明等硕士特有页面
}

% 4. 覆盖页眉页脚
\AddToHook{sduthesis/mainmatter/begin}{%
  \pagestyle{fancy}
  \fancyhead[C]{\zihao{5}\songti 山东大学硕士学位论文}
  \fancyhead[R]{\zihao{5}\songti\leftmark}
}

\endinput
```

### 第 3 步：加载方式

用户在 `sdusetup.tex` 中设置：

```latex
\SDUSetup{
  module = master,
}
```

内核会自动加载 `sduthesis-master.sty`。

### 模块可以做什么

| 方式 | 用途 | 示例 |
|------|------|------|
| `\renewcommand` | 覆盖内核的空实现 | `\renewcommand{\makecoverpage}{...}` |
| `\renewenvironment` | 覆盖摘要等环境 | `\renewenvironment{cnabstract}{...}{}` |
| `\AddToHook` | 在特定阶段注入行为 | `\AddToHook{sduthesis/frontmatter/begin}{...}` |

### 可用的 Hook

| Hook 名称 | 触发时机 | 用途 |
|-----------|---------|------|
| `sduthesis/after-setup` | SDUSetup 处理完成后 | 根据配置调整样式 |
| `sduthesis/before-cover` | 封面页之前 | 插入前置页面 |
| `sduthesis/cover-style` | 封面样式 | 覆盖封面排版 |
| `sduthesis/frontmatter/begin` | 前言开始 | 声明页、摘要 |
| `sduthesis/mainmatter/begin` | 正文开始 | 页眉页脚切换 |
| `sduthesis/backmatter/begin` | 后记开始 | 致谢、附录 |

---

## 代码规范

### LaTeX3 命名

| 类型 | 格式 | 示例 |
|------|------|------|
| 内部变量 | `\l__sdu_<name>_<type>` | `\l__sdu_title_tl` |
| 内部函数 | `\sdu_<name>:` | `\sdu_load_module:` |
| 用户命令 | `\CamelCase` | `\SDUSetup`、`\GetTitle` |

### 关键约束

1. **LaTeX3 函数必须在 `\ExplSyntaxOn` 区域内调用**，包括 `\AddToHook` 中的回调。见 [CI-TROUBLESHOOTING.md](CI-TROUBLESHOOTING.md) 问题 3。

2. **`\renewcommand` 而非 `\newcommand`** — 内核定义空实现，模块覆盖。不用 `\newcommand` 是因为命令已存在。

3. **模块加载时序** — 模块在 `\begin{document}` 时加载（通过 `\AddToHook{begindocument}`），早于 main.tex 中的任何排版命令。

---

## 开发流程

```
1. 从 develop 切分支（feat/fix/docs/refactor）
2. 开发 + 本地测试
3. 推送分支 → 创建 PR → develop
4. CI 自动检查
5. Review + 合并
6. 版本发布时 develop → main
```

### 本地测试

```bash
# 安装 just（如果还没有）
cargo install just    # 或 brew install just

# 编译
just build

# 清理
just distclean
```

### CI 注意事项

- 使用 `setup-texlive-action` 时**必须符号链接字体目录**（见 [CI-TROUBLESHOOTING.md](CI-TROUBLESHOOTING.md)）
- `.github/tl_packages` 使用 collection 整组安装，不要手动逐个列包
- 修改 `.github/workflows/*` 后注意 OAuth token 可能没有 workflow scope

---

## 发布流程

1. 确认 develop 上 CI 全绿
2. 创建 PR：develop → main
3. 合并后打 tag：`git tag v1.2.0 && git push origin v1.2.0`
4. tag 触发 release.yml，自动编译 + git-cliff changelog + GitHub Release
