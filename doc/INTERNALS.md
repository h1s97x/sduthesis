# SDUThesis 技术文档

> 本文档面向开发者/维护者，记录项目架构、核心机制和设计决策。
> 面试准备时重点关注 **l3keys 机制**、**Hook 系统**、**插件化架构**、**CI/CD 流水线** 四个部分。

---

## 1. 项目概览

SDUThesis 是山东大学毕业论文 LaTeX 模板，采用内核 + 模块的插件化架构。内核提供基础排版引擎和 Hook 系统，模块负责特定论文类型的格式和内容。

**技术栈**：LaTeX3 (expl3) + l3keys + Hook 系统 + XeLaTeX + biblatex + biber

**协议**：LPPL-1.3c (LaTeX Project Public License)

---

## 2. 核心架构：内核 + 模块 + 用户层

```
┌─────────────────────────────────────────┐
│           用户层 (User Layer)            │
│   sdusetup.tex + data/ + main.tex       │
├─────────────────────────────────────────┤
│         模块层 (Module Layer)            │
│   undergraduate.sty  master.sty  ...    │
│   blindreview.sty    english.sty  ...   │
├─────────────────────────────────────────┤
│           内核 (Core Engine)             │
│   sduthesis.cls                         │
│   ├── SDUSetup 引擎 (l3keys)            │
│   ├── Hook 系统                         │
│   ├── 字体加载器                        │
│   └── 页面引擎                          │
├─────────────────────────────────────────┤
│         基础层 (Base Layer)              │
│   LaTeX3 + ctex + xecjk + biblatex      │
└─────────────────────────────────────────┘
```

设计原则：**内核不知道什么是"本科封面"，只知道"有个 cover-style 钩子，谁加载谁负责"**。

### 文件调用链

```
main.tex
├── \documentclass{sduthesis}         ← 加载内核
│   ├── ctexbook                      ← 基础文档类
│   ├── SDUSetup 引擎                 ← l3keys 键值定义 + Getter
│   ├── Hook 定义                     ← \NewHook{sduthesis/*}
│   ├── 字体/页面/章节/引用引擎        ← 基础排版
│   └── 通用环境                      ← myacknowledgement, myappendix, printbib, maketable
│
├── \input{sdusetup.tex}              ← 用户设置 \SDUSetup{module=undergraduate, ...}
│
└── \begin{document}
    ├── \AtBeginDocument              ← 自动加载 sduthesis-undergraduate.sty
    │   ├── \renewcommand{\makecoverpage}  ← 封面排版
    │   ├── \renewenvironment{cnabstract}  ← 摘要环境
    │   └── \AddToHook{sduthesis/*}       ← 页眉页脚、章节格式
    │
    ├── \UseHook{sduthesis/frontmatter/begin}  ← 前言钩子
    ├── \makecoverpage                          ← 本科封面
    ├── \UseHook{sduthesis/mainmatter/begin}   ← 正文钩子
    ├── \UseHook{sduthesis/backmatter/begin}   ← 后记钩子
    └── \end{document}
```

---

## 3. l3keys 机制

`\SDUSetup{}` 基于 LaTeX3 的 l3keys 包实现，是整个模板的配置核心。

### 三步链路

```
① 变量声明          ② 键定义              ③ 用户命令
\tl_new:N       →  \keys_define:nn    →  \SDUSetup{}
\l__sdu_title_tl    title .tl_set:N       {title = {xxx}}
```

**第一步：声明存储变量**

```latex
\tl_new:N \l__sdu_title_tl    % token list 变量
```

- 命名规则：`\l_` (局部) + `__sdu_` (模块前缀) + `title` (语义) + `_tl` (类型)
- 变量类型：`_tl` = token list（字符串），`_dim` = 尺寸

**第二步：注册键**

```latex
\keys_define:nn { sdu } {
  title .tl_set:N = \l__sdu_title_tl,
}
```

- `sdu` 是键空间（namespace）
- `.tl_set:N` 表示将值存入 token list 变量
- 其他属性：`.initial:n`（默认值）、`.default:n`（省略值时的默认值）

**第三步：创建用户命令**

```latex
\NewDocumentCommand \SDUSetup { m } {
  \keys_set:nn { sdu } { #1 }
}
```

- `\keys_set:nn` 将键值对写入对应的变量

### Getter 导出

```latex
\NewDocumentCommand \GetTitle { } { \l__sdu_title_tl }
```

用户写 `\GetTitle`，展开为 `\l__sdu_title_tl` 的当前值。因为 LaTeX 是延迟展开，`\GetTitle` 在调用时才取值，所以 `\SDUSetup` 可以在 `\GetTitle` 之前定义。

---

## 4. Hook 系统

内核在文档编译各阶段埋入钩子，模块通过 `\AddToHook` 注入行为。

### 可用钩子

| 钩子 | 触发时机 | 用途 |
|------|----------|------|
| `sduthesis/after-setup` | SDUSetup 之后，\begin{document} 时 | 根据配置调整行为 |
| `sduthesis/before-cover` | 封面前 | 插入声明页等 |
| `sduthesis/cover-style` | 封面样式 | 模块覆盖封面排版 |
| `sduthesis/frontmatter/begin` | 前言开始 | 设置页眉页脚 |
| `sduthesis/mainmatter/begin` | 正文开始 | 设置正文页眉页脚 |
| `sduthesis/backmatter/begin` | 后记开始 | 调整章节格式 |

### 模块如何使用 Hook

```latex
% modules/sduthesis-undergraduate.sty
\AddToHook{sduthesis/mainmatter/begin}{
    % 本科论文的正文页眉
    \fancypagestyle{plain}{...}
    \pagestyle{plain}
}
```

### Hook 的优势

- **解耦**：内核不包含任何论文类型特有逻辑
- **可组合**：多个模块可以挂载同一个 Hook
- **可覆盖**：后加载的模块可以覆盖先加载的

---

## 5. 模块系统

### 模块加载机制

```latex
% sduthesis.cls 中的模块加载器
\AtBeginDocument{
  \sdu_load_module:    % 加载 sduthesis-<module>.sty
  \UseHook{sduthesis/after-setup}
}
```

`\SDUSetup{module=undergraduate}` 设置模块名，`\sdu_load_module:` 在 `\begin{document}` 时查找并加载 `sduthesis-undergraduate.sty`。

### 模块可以做什么

1. **`\renewcommand`** 覆盖内核中的默认实现（如 `\makecoverpage`）
2. **`\renewenvironment`** 覆盖默认环境（如 `cnabstract`、`enabstract`）
3. **`\AddToHook`** 在编译阶段注入行为
4. **`\keys_define:nn`** 注册模块特有的配置键

### 新增模块的步骤

1. 创建 `modules/sduthesis-<name>.sty`
2. 用 `\renewcommand`/`\renewenvironment` 覆盖封面和环境
3. 用 `\AddToHook` 注入页眉页脚和章节格式
4. 用户通过 `\SDUSetup{module=<name>}` 加载

---

## 6. 字体系统

### 为什么选 Fandol

| 字体族 | 来源 | 大小 | TeX Live 自带 | Windows 自带 |
|--------|------|------|:---:|:---:|
| FandolSong/Hei/Kai | 开源 | ~15MB | ✅ | ❌ |
| SimSun/SimHei/KaiTi | 商业 | ~30MB | ❌ | ✅ |
| Noto CJK | 开源 | ~200MB | ❌ | ❌ |

Fandol 是 TeX Live 自带的中文字体，保证 CI 和最小安装环境都能编译。用户可以在 `sdusetup.tex` 中覆盖为系统字体。

### 字体加载机制

```latex
\let\songti\relax       % 先取消 ctex 的默认定义
\newCJKfontfamily\songti{FandolSong}   % 重新定义
```

ctex 会自动配置中文字体，但其默认配置可能与我们的需求冲突。所以先用 `\let\songti\relax` 清除，再用 `\newCJKfontfamily` 重新指定。

### 英文字体

- 衬线：Latin Modern Roman（Computer Modern 增强版）
- 无衬线：Latin Modern Sans
- 等宽：Latin Modern Mono
- 数学：Latin Modern Math

---

## 7. 参考文献系统

### 技术方案

biblatex + biber + gb7714-2015 样式，符合 GB/T 7714-2015 参考文献著录规则。

```latex
\usepackage[
    backend=biber,
    style=gb7714-2015,
    gbnamefmt=givenahead
]{biblatex}
```

### 编译流程

为什么需要 xelatex × 3 + biber 四次编译：

1. **xelatex** — 生成 .aux 文件，记录引用信息
2. **biber** — 读取 .bcf，处理 .bib，生成 .bbl
3. **xelatex** — 读取 .bbl，写入引用到 .aux
4. **xelatex** — 解析交叉引用，生成最终 PDF

### 引用命令

| 命令 | 效果 | 示例 |
|------|------|------|
| `\citing{key}` | 上标数字 | 文章^1 |
| `\citex{key}` | 括号引用 | (Author, Year) |

---

## 8. CI/CD 流水线

### Build Workflow

触发条件：push/PR 到 main 或 develop

```
checkout → setup-texlive → install-just → just build → upload-artifact
```

关键配置：
- TeX Live 2025 + `.github/tl_packages` 依赖列表
- 使用 `collection-*` 整组安装，避免缺包

### Release Workflow

触发条件：推送 v* tag

```
checkout → setup-texlive → install-just → just build
→ git-cliff (CHANGELOG) → gh-release (上传 PDF)
```

---

## 9. 设计决策记录

| 决策 | 选择 | 原因 |
|------|------|------|
| 配置机制 | l3keys | LaTeX3 标准，支持分组、默认值、类型检查 |
| 字体 | Fandol | TeX Live 自带，CI 和最小安装环境都能用 |
| 参考文献样式 | gb7714-2015 | 符合国标 GB/T 7714-2015 |
| 构建工具 | just | 比 Make 语法更简洁，跨平台 |
| 架构 | 内核 + 模块 | 解耦论文类型，方便扩展 |
| Hook 机制 | \NewHook/\AddToHook | LaTeX3 标准钩子，比 \AtBeginDocument 更精确 |
