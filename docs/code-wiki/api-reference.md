# 关键类与函数说明

> [返回首页](./README.md) | [上一节：模块职责](./modules.md) | [下一节：依赖关系](./dependencies.md)

---

## 内核变量（LaTeX3 存储层）

所有配置值通过 token list（`_tl`）或 dimension（`_dim`）变量存储，命名规范：`\l__sdu_<名称>_<类型>`。

### 信息组变量

| 变量 | 类型 | 对应键 | 用途 |
|------|------|--------|------|
| `\l__sdu_title_tl` | tl | `title` | 论文标题 |
| `\l__sdu_author_tl` | tl | `author` | 作者姓名 |
| `\l__sdu_studentid_tl` | tl | `studentId` | 学号 |
| `\l__sdu_school_tl` | tl | `school` | 学院 |
| `\l__sdu_major_tl` | tl | `major` | 专业 |
| `\l__sdu_supervisor_tl` | tl | `supervisor` | 指导教师 |
| `\l__sdu_year_tl` | tl | `year` | 毕业年份 |
| `\l__sdu_month_tl` | tl | `month` | 毕业月份 |

> 上述键在 `sdu/info` 组注册（v2.2.0+ 经 `info={...}` 传入，或平铺写在顶层）。

### 学位信息组变量（master/doctor 使用）

| 变量 | 类型 | 对应键 | 默认值 |
|------|------|--------|--------|
| `\l__sdu_degree_tl` | tl | `degree` | `硕士` |
| `\l__sdu_committee_chair_tl` | tl | `committeeChair` | — |
| `\l__sdu_committee_members_tl` | tl | `committeeMembers` | — |
| `\l__sdu_defense_date_tl` | tl | `defenseDate` | — |
| `\l__sdu_defense_place_tl` | tl | `defensePlace` | — |

### 样式组变量

| 变量 | 类型 | 对应键 | 默认值 |
|------|------|--------|--------|
| `\l__sdu_line_spread_dim` | dim | `lineSpread` | `1.5` |
| `\l__sdu_page_left_tl` | tl | `pageLeft` | `3cm` |
| `\l__sdu_page_right_tl` | tl | `pageRight` | `3cm` |
| `\l__sdu_page_top_tl` | tl | `pageTop` | `2.5cm` |
| `\l__sdu_page_bottom_tl` | tl | `pageBottom` | `2.5cm` |

> 上述键在 `sdu/option` 组注册（v2.2.0+ 经 `option={...}` 传入，或平铺写在顶层）。

### 模块组变量

| 变量 | 类型 | 用途 |
|------|------|------|
| `\l__sdu_module_tl` | tl | 模块名列表字符串（默认 `undergraduate`） |
| `\l__sdu_module_seq` | seq | 模块名拆分后的序列 |
| `\l__sdu_module_tmp_tl` | tl | 模块加载过程中的临时变量 |
| `\l__sdu_module_item_tl` | tl | 当前正在处理的模块项 |
| `\l__sdu_module_pkg_tl` | tl | 组装出的包名（`sduthesis-<name>`） |
| `\l__sdu_blindreview_bool` | bool | 盲审标志（blindreview 模块加载时置真） |
| `\l__sdu_has_blindreview_bool` | bool | 列表中是否含 blindreview |
| `\l__sdu_has_base_module_bool` | bool | 列表中是否已有基础模块 |

---

## 内核核心函数

### `\SDUSetup` —— 用户配置命令

```latex
\NewDocumentCommand \SDUSetup { m } { \keys_set:nn { sdu } { #1 } }
```

- **入参**：键值对（如 `module = undergraduate, title = {xxx}`）
- **机制**：调用 l3keys 的 `\keys_set:nn` 将键值写入对应变量
- **调用时机**：用户在 `sdusetup.tex` 中调用，可在 `\GetTitle` 等之前定义（LaTeX 延迟展开）

**键的组织方式**（v2.2.0+ 支持两种写法，可混用，共享同一组内部变量）：

- **嵌套分组（推荐）**：`info = { title = {...}, author = {...}, ... }` 收纳论文元数据，`option = { lineSpread = 1.5, pageLeft = 3cm, ... }` 收纳样式参数，`module` 留在顶层。`info` 与 `option` 是 `.code:n` 代理键，内部转发到 `sdu/info`、`sdu/option` 子组。
- **平铺写法（兼容旧版）**：所有键（含 `title`、`degree`、`lineSpread` 等）直接写在顶层，由 `sdu` 组的同名平铺别名键接收。

内核通过三个键组实现：`sdu/info`（论文信息 + 学位信息）、`sdu/option`（排版参数）、`sdu`（`module` + `info`/`option` 代理 + 平铺别名）。

### `\sdu_load_module:` —— 模块加载器

内核核心函数，位于 [src/sduthesis.dtx](file:///workspace/src/sduthesis.dtx)，处理多模块组合加载与盲审回退：

1. 将 `module` 字符串按逗号拆分为序列
2. **扫描阶段**：判断是否含 `blindreview`、是否已有基础模块（`undergraduate`/`master`）
3. **盲审回退**：若含 `blindreview` 但缺基础模块，前置加载 `sduthesis-undergraduate`
4. **正式加载**：按用户指定顺序依次 `\RequirePackage{sduthesis-<name>}`

通过 `\AddToHook{begindocument}` 在 `\begin{document}` 时触发，确保 `SDUSetup` 已被调用。

### Getter 命令族

每个信息键对应一个 Getter，读取对应变量并展开。由于 LaTeX 延迟展开，Getter 在调用时才取值：

| 命令 | 对应键 | 命令 | 对应键 |
|------|--------|------|--------|
| `\GetTitle` | `title` | `\GetYear` | `year` |
| `\GetAuthor` | `author` | `\GetMonth` | `month` |
| `\GetStudentId` | `studentId` | `\GetDegree` | `degree` |
| `\GetSchool` | `school` | `\GetCommitteeChair` | `committeeChair` |
| `\GetMajor` | `major` | `\GetCommitteeMembers` | `committeeMembers` |
| `\GetSupervisor` | `supervisor` | `\GetDefenseDate` | `defenseDate` |
| | | `\GetDefensePlace` | `defensePlace` |

### 盲审标志命令

| 命令 | 签名 | 行为 |
|------|------|------|
| `\IfBlindReviewTF` | `{#1}{#2}` | 盲审输出 `#1`，否则 `#2` |
| `\IfBlindReviewF` | `{#1}` | 非盲审才输出 `#1`（盲审时为空）—— 用于封面个人信息行 |
| `\IfBlindReview` | `{#1}{#2}` | 用户层命令（封装 `\IfBlindReviewTF`） |

底层实现：

```latex
\cs_new:Npn \IfBlindReviewTF #1 #2 { \bool_if:NTF \l__sdu_blindreview_bool { #1 } { #2 } }
\cs_new:Npn \IfBlindReviewF #1 { \bool_if:NF \l__sdu_blindreview_bool { #1 } }
```

---

## Hook 系统

内核定义 6 个文档阶段钩子，模块通过 `\AddToHook` 注入行为：

| Hook 名称 | 触发时机 | 典型用途 |
|-----------|----------|----------|
| `sduthesis/after-setup` | SDUSetup 完成后，`\begin{document}` 时 | 根据配置调整行为 |
| `sduthesis/before-cover` | 封面前 | 插入声明页等前置页面 |
| `sduthesis/cover-style` | 封面样式 | 模块覆盖封面排版 |
| `sduthesis/frontmatter/begin` | 前言开始（`\frontmatter` 后） | 设置前言页眉页脚 |
| `sduthesis/mainmatter/begin` | 正文开始（`\mainmatter` 后） | 设置正文页眉页脚 |
| `sduthesis/backmatter/begin` | 后记开始（`\backmatter` 后） | 调整后记章格式 |

Hook 优势：
- **解耦**：内核不含任何论文类型特有逻辑
- **可组合**：多模块可挂载同一 Hook
- **可覆盖**：后加载的模块可覆盖先加载的

---

## 字体引擎

### 字体选择策略

模板使用 TeX Live 自带的 **Fandol 开源中文字体**，保证 CI 和最小安装环境都能编译：

| 字体族 | 来源 | 大小 | TeX Live 自带 |
|--------|------|------|:---:|
| FandolSong/Hei/Kai | 开源 | ~15MB | ✅ |
| SimSun/SimHei/KaiTi | 商业 | ~30MB | ❌ |
| Noto CJK | 开源 | ~200MB | ❌ |

### 字体加载机制

ctex 会自动配置中文字体，但其默认配置可能与需求冲突。模板先释放 ctex 预定义的字体命令，再用 Fandol 重新定义：

```latex
\let\songti\relax       % 先取消 ctex 的默认定义（避免 already defined 错误）
\let\heiti\relax
\let\kaiti\relax

\newCJKfontfamily\songti{FandolSong}
\newCJKfontfamily\heiti{FandolHei}
\newCJKfontfamily\kaiti{FandolKai}
```

并提供字体族快捷命令：`\song`/`\hei`/`\kai`/`\bfsong`/`\bfhei`/`\itsong`/`\allbfsong` 等（含组合样式 `bf`/`it`/`bfit` × `song`/`hei`/`kai`）。

英文字体和数学字体使用 LaTeX 默认（Latin Modern 系列），用户可在 `sdusetup.tex` 中用 `\setmainfont` 等自定义。

---

## 引用与交叉引用命令

| 命令 | 效果 | 实现 |
|------|------|------|
| `\citing{key}` | 上标数字引用 | `\let\citing\supercite` |
| `\citex{key}` | 括号引用 (Author, Year) | `\let\citex\citep` |
| `\figref{label}` | "图 X" | `\newcommand{\figref}[1]{图\ \ref{#1}\ }` |
| `\tabref{label}` | "表 X" | 类似 |
| `\equref{label}` | "式 X" | 类似 |
| `\subfigref{label}` | 子图引用 | 基于 `\subref*` |

---

## 章节引擎

通过 `\ctexset` 配置中文章节格式（命名 `第X章`），三级层次（chapter/section/subsection）：

| 层级 | 字号 | 字体 | 编号格式 |
|------|------|------|----------|
| chapter | 三号 | 黑体加粗 | 第一章（居中） |
| section | 四号 | 黑体加粗 | 1.1 |
| subsection | 小四号 | 黑体加粗 | 1.1.1 |

`secnumdepth=3` 控制编号深度，`fixskip=true` 修复 ctex 章节间距问题。

---

## 参考文献系统

```latex
\usepackage[
    backend=biber,
    style=gb7714-2015,
    gbnamefmt=givenahead
]{biblatex}
\addbibresource{data/ref/references.bib}
```

- **样式**：`gb7714-2015`（符合国标 GB/T 7714-2015 参考文献著录规则）
- **后端**：`biber`（而非传统 `bibtex`）
- **名字格式**：`givenahead`（名在前姓在后，符合 gb7714 要求）
- **`\printbib`**：参考文献打印命令，生成 `\chapter*{参考文献}` 并加入目录
