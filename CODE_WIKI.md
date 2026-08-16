# SDUThesis Code Wiki

> 山东大学毕业论文 LaTeX 模板的结构化代码文档
> 版本：v2.1.0 | 协议：LPPL-1.3c | 维护者：h1s97x
> 仓库：https://github.com/h1s97x/sduthesis

---

## 目录

- [1. 项目概览](#1-项目概览)
- [2. 项目整体架构](#2-项目整体架构)
- [3. 目录结构](#3-目录结构)
- [4. 主要模块职责](#4-主要模块职责)
- [5. 关键类与函数说明](#5-关键类与函数说明)
- [6. 依赖关系](#6-依赖关系)
- [7. 项目运行方式](#7-项目运行方式)
- [8. 测试体系](#8-测试体系)
- [9. CI/CD 流水线](#9-cicd-流水线)
- [10. 开发指南](#10-开发指南)
- [11. 设计决策记录](#11-设计决策记录)

---

## 1. 项目概览

### 1.1 项目简介

`sduthesis` 是为山东大学学位论文设计的 LaTeX 模板，基于《山东大学本科毕业论文（设计）撰写规范》编写。模板采用 **内核 + 模块** 的插件化架构，通过 `\SDUSetup{}` 集中配置，支持本科、硕士、博士等不同学位类型论文，并支持盲审模式。

### 1.2 技术栈

| 层级 | 技术 |
|------|------|
| 编程范式 | LaTeX3 (expl3) 编程接口 |
| 配置机制 | l3keys 键值系统 |
| 扩展机制 | LaTeX Hook 系统（`\NewHook` / `\AddToHook`） |
| 编译器 | XeLaTeX |
| 中文支持 | ctex + xeCJK + Fandol 开源字体 |
| 参考文献 | biblatex + biber + gb7714-2015 样式 |
| 构建工具 | just + latexmk + l3build |
| CI/CD | GitHub Actions + CNB 流水线 |
| 版本控制 | Git（GitHub + CNB 双向同步） |
| 协议 | LPPL-1.3c (LaTeX Project Public License) |

### 1.3 核心特性

- **插件化架构**：内核提供基础排版引擎和 Hook 系统，模块负责特定论文类型的格式和内容
- **集中配置**：通过 `\SDUSetup{}` 统一管理论文信息与样式，内容与样式分离
- **多模块组合**：`module` 键支持逗号分隔的模块列表（如 `{master, blindreview}`），按顺序加载实现功能叠加
- **盲审模式**：隐藏作者、学号、导师、答辩委员会成员等个人信息
- **跨平台**：支持 Windows / macOS / Linux / Overleaf / TeXPage
- **开源字体**：使用 TeX Live 自带的 Fandol 字体，无需额外安装
- **自动化 CI/CD**：GitHub Actions 三段式流水线（质量检查 / 构建 / 发布）

---

## 2. 项目整体架构

### 2.1 四层架构

```
┌─────────────────────────────────────────┐
│           用户层 (User Layer)            │
│   sdusetup.tex + data/ + main.tex       │
├─────────────────────────────────────────┤
│         模块层 (Module Layer)            │
│   undergraduate.sty  master.sty          │
│   blindreview.sty                       │
├─────────────────────────────────────────┤
│           内核 (Core Engine)             │
│   sduthesis.cls                         │
│   ├── SDUSetup 引擎 (l3keys)            │
│   ├── Hook 系统                         │
│   ├── 模块加载器                        │
│   ├── 字体加载器                        │
│   └── 页面/章节/引用引擎                 │
├─────────────────────────────────────────┤
│         基础层 (Base Layer)              │
│   LaTeX3 + ctexbook + xeCJK + biblatex   │
└─────────────────────────────────────────┘
```

**核心设计原则**：内核不知道什么是"本科封面"，只知道"有个 `cover-style` 钩子，谁加载谁负责"。所有论文类型特有的排版逻辑通过模块注入，内核只提供基础设施。

### 2.2 文件调用链

```
main.tex
├── \documentclass{sduthesis}         ← 加载内核
│   ├── ctexbook                       ← 基础文档类
│   ├── SDUSetup 引擎                  ← l3keys 键值定义 + Getter
│   ├── Hook 定义                      ← \NewHook{sduthesis/*}
│   ├── 字体/页面/章节/引用引擎        ← 基础排版
│   └── 通用环境                       ← myacknowledgement / myappendix / printbib / maketable
│
├── \input{sdusetup.tex}               ← 用户设置 \SDUSetup{module=undergraduate, ...}
│
└── \begin{document}
    ├── \AtBeginDocument               ← 自动加载 sduthesis-<module>.sty
    │   ├── \renewcommand{\makecoverpage}  ← 封面排版
    │   ├── \renewenvironment{cnabstract}  ← 摘要环境
    │   └── \AddToHook{sduthesis/*}        ← 页眉页脚、章节格式
    │
    ├── \frontmatter
    ├── \UseHook{sduthesis/frontmatter/begin}  ← 前言钩子
    ├── \makecoverpage                          ← 封面
    ├── \input{data/frontmatter/abstract.tex}   ← 摘要内容
    ├── \maketable                              ← 目录
    │
    ├── \mainmatter
    ├── \UseHook{sduthesis/mainmatter/begin}   ← 正文钩子
    ├── \input{data/chapters/chapterN.tex}     ← 正文章节
    │
    ├── \begin{myappendix}                     ← 附录（必须在 \backmatter 前）
    │
    ├── \backmatter
    ├── \UseHook{sduthesis/backmatter/begin}  ← 后记钩子
    ├── \printbib                              ← 参考文献
    └── \begin{myacknowledgement}              ← 致谢
```

### 2.3 DTX 源码 → 生成产物

模板核心采用 LaTeX 社区标准的 DTX（Documented TeX）格式：

```
src/sduthesis.dtx  ──[xelatex sduthesis.ins]──>  sduthesis.cls
                  └─[xelatex sduthesis.dtx]──>  sduthesis-doc.pdf（开发者文档）
```

- `src/sduthesis.dtx`：内核源码 + 使用手册（同一文件同时承载代码与文档）
- `src/sduthesis.ins`：docstrip 安装脚本，从 DTX 提取 `.cls`
- `sduthesis.cls`：**生成文件**，由 docstrip 产生，**不要手动编辑**（仓库中已提交以便 Overleaf 直接编译）

---

## 3. 目录结构

```
sduthesis/
├── src/                            # DTX 源码（开发者维护）
│   ├── sduthesis.dtx               #   内核源码 + 使用手册
│   └── sduthesis.ins               #   安装脚本（从 .dtx 提取 .cls）
├── sduthesis.cls                   # 生成文件（从 .dtx 提取，不要手动编辑）
├── sdusetup.tex                    # 用户配置（论文信息 + 模块选择）
├── main.tex                        # 主文件（编译入口）
│
├── modules/                        # 功能模块（插件）
│   ├── sduthesis-undergraduate.sty #   本科论文模块
│   ├── sduthesis-master.sty        #   硕士学位论文模块
│   └── sduthesis-blindreview.sty   #   盲审模式模块（叠加层）
│
├── data/                           # 论文内容（用户编辑区）
│   ├── frontmatter/                #   摘要、致谢、附录
│   ├── chapters/                   #   正文章节（chapter1~5）
│   └── ref/references.bib          #   参考文献数据库
│
├── figures/                        # 图片资源
│   └── logos/                      #   校徽校名（sdu_logo_2.pdf / sdu_title.png）
│
├── testfiles/                      # l3build 回归测试
│   ├── support/setup-test.tex      #   测试公共配置
│   ├── *.tex                       #   测试用例（cover/abstract/toc/bib/...）
│   └── *.tlg                       #   回归对比基线
│
├── tests/
│   └── test-compile.py             # 完整编译测试脚本
│
├── scripts/                        # 工具脚本
│   ├── build-ctan.sh               #   构建 CTAN 提交包
│   ├── build-overleaf.sh           #   构建 Overleaf 模板包
│   └── l3build-check.sh            #   l3build 回归门禁逻辑
│
├── doc/                            # 文档
│   ├── FAQ.md                      #   常见问题
│   ├── INTERNALS.md                #   技术文档（架构与机制）
│   ├── DEVELOP.md                  #   开发指南
│   ├── ROADMAP.md                  #   项目方案与路线图
│   ├── OPTIMIZATION-PLAN.md        #   优化计划
│   ├── OVERLEAF.md                  #   Overleaf 使用说明
│   ├── CTAN-SUBMISSION.md          #   CTAN 提交清单
│   └── CI-TROUBLESHOOTING.md       #   CI 故障排查
│
├── .github/                        # GitHub Actions CI
│   ├── workflows/
│   │   ├── quality.yml             #   代码质量（lint + 回归）
│   │   ├── build.yml               #   构建 PDF（TeX Live 2025/2026 矩阵）
│   │   ├── release.yml             #   tag 发布
│   │   └── sync-cnb.yml            #   GitHub → CNB 反向同步
│   ├── tl_packages                #   完整 TeX Live 包列表
│   ├── tl_packages_lint           #   精简 lint 环境包列表
│   ├── ISSUE_TEMPLATE/            #   Issue 模板
│   ├── PULL_REQUEST_TEMPLATE.md   #   PR 模板
│   └── CODEOWNERS                 #   代码所有者
│
├── .cnb.yml                        # CNB 流水线配置
├── .cnb/web_trigger.yml            # CNB Web 触发器
│
├── justfile                        # 构建脚本（just）
├── build.lua                       # l3build 配置
├── latexmkrc                        # latexmk 配置（Overleaf 用）
├── .chktexrc                       # chktex lint 规则
├── cliff.toml                      # git-cliff changelog 配置
├── README.md / README              # 项目说明（Markdown + 纯文本）
├── CHANGELOG.md                    # 变更日志（git-cliff 生成）
├── RELEASE_NOTES.md                # 发布说明
├── CONTRIBUTING.md                 # 贡献指南
└── LICENSE                         # LPPL-1.3c 协议
```

---

## 4. 主要模块职责

### 4.1 内核（`sduthesis.cls` / `src/sduthesis.dtx`）

内核只提供四件事，**不包含任何论文类型特有的排版逻辑**：

| 职责 | 说明 |
|------|------|
| **SDUSetup 引擎** | 基于 l3keys 的键值注册表 + Getter 导出机制 |
| **Hook 系统** | 在文档编译各阶段埋入 6 个钩子 |
| **模块加载器** | `\sdu_load_module:` 解析逗号分隔的模块列表并按顺序加载，含盲审回退逻辑 |
| **基础排版** | 页面尺寸、行距、章节编号、字体、参考文献、图表标题、代码排版引擎 |

内核提供的"占位命令"在未被模块覆盖时会发出警告：

| 占位项 | 类型 | 默认行为 |
|--------|------|----------|
| `\makecoverpage` | 命令 | 发出 `PackageWarning`（请加载模块） |
| `\makestatement` | 命令 | 发出 `PackageWarning` |
| `\makecommittee` | 命令 | 发出 `PackageWarning` |
| `cnabstract` | 环境 | 空实现 `{}` `{}` |
| `enabstract` | 环境 | 空实现 `{}` `{}` |
| `\cnkeywords` | 命令 | 空参数 `#1` |
| `\enkeywords` | 命令 | 空参数 `#1` |

内核定义的通用环境（不依赖模块）：

| 环境/命令 | 职责 |
|-----------|------|
| `myacknowledgement` | 致谢环境（含目录条目、页眉处理） |
| `myappendix` | 附录环境（切换 `\appendix` 编号、附录公式/表/图编号带章节前缀） |
| `\printbib` | 参考文献打印（`\chapter*{参考文献}` + `\printbibliography`） |
| `\maketable` | 目录（罗马页码、定制目录样式、书签） |

### 4.2 模块层

| 模块 | 文件 | 类型 | 通过何种方式加载 |
|------|------|------|------------------|
| `undergraduate` | `modules/sduthesis-undergraduate.sty` | 基础模块（默认） | `\SDUSetup{module=undergraduate}` |
| `master` | `modules/sduthesis-master.sty` | 基础模块 | `\SDUSetup{module=master}` |
| `blindreview` | `modules/sduthesis-blindreview.sty` | 叠加层模块 | `\SDUSetup{module={master,blindreview}}` |

#### 4.2.1 `undergraduate` 模块职责

- 覆盖 `\makecoverpage`：本科封面（校徽、校名、论文题目、姓名/学号/学院/专业/指导教师表格、年月）
- 覆盖 `cnabstract` / `enabstract` 环境：中英文摘要格式（标题、缩进、字号）
- 覆盖 `\cnkeywords` / `\enkeywords`：关键词样式
- 注入 Hook：
  - `sduthesis/frontmatter/begin` → 前言空白页眉页脚
  - `sduthesis/mainmatter/begin` → 正文页眉"山东大学本科毕业论文（设计）" + 1.3 行距
  - `sduthesis/backmatter/begin` → 后记章标题小二号居中加粗

#### 4.2.2 `master` 模块职责

- 覆盖 `\makecoverpage`：硕士封面（与本科类似，新增"学位类型"行）
- 覆盖 `\makecommittee`：**答辩委员会页**（主席/委员/答辩日期/答辩地点，盲审时整页跳过）
- 覆盖摘要环境与关键词（与 undergraduate 一致）
- 注入 Hook：正文页眉为"山东大学硕士学位论文"
- 新增配置键（在内核已注册）：`degree` / `committeeChair` / `committeeMembers` / `defenseDate` / `defensePlace`

#### 4.2.3 `blindreview` 模块职责（叠加层）

盲审模块**不定义封面版式**，通过三层机制隐藏个人信息：

1. **设置盲审标志**：`\bool_set_true:N \l__sdu_blindreview_bool`（基础模块封面通过 `\IfBlindReviewF` 决定是否输出个人信息行）
2. **覆盖 Getter**：将 `\GetAuthor` / `\GetStudentId` / `\GetSupervisor` / `\GetCommitteeChair` / `\GetCommitteeMembers` 全部覆写为 `***`，摘要/致谢等处的作者名同样被隐藏
3. **跳过整页**：`\makestatement` 置空（跳过声明页）、`\makecommittee` 置空（跳过答辩委员会页，避免泄露主席/委员姓名）

**盲审回退**：若 `module` 列表含 `blindreview` 但缺少基础模块（`undergraduate`/`master`），内核加载器会**自动前置加载本科模块**，与书写顺序无关（如 `{blindreview, master}` 只加载 `master` 一个基础模块）。

### 4.3 用户层

| 文件 | 职责 |
|------|------|
| `main.tex` | 编译入口，组装前言/正文/附录/后记结构 |
| `sdusetup.tex` | 用户配置，调用 `\SDUSetup{}` 设置论文信息与模块 |
| `data/frontmatter/` | 摘要、致谢、附录内容 |
| `data/chapters/` | 正文章节（chapter1~5） |
| `data/ref/references.bib` | BibTeX 参考文献数据库 |
| `figures/` | 图片资源（含 `logos/` 校徽校名） |

---

## 5. 关键类与函数说明

### 5.1 内核变量（LaTeX3 存储层）

所有配置值通过 token list（`_tl`）或 dimension（`_dim`）变量存储，命名规范：`\l__sdu_<名称>_<类型>`。

#### 信息组变量

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

#### 学位信息组变量（master/doctor 使用）

| 变量 | 类型 | 对应键 | 默认值 |
|------|------|--------|--------|
| `\l__sdu_degree_tl` | tl | `degree` | `硕士` |
| `\l__sdu_committee_chair_tl` | tl | `committeeChair` | — |
| `\l__sdu_committee_members_tl` | tl | `committeeMembers` | — |
| `\l__sdu_defense_date_tl` | tl | `defenseDate` | — |
| `\l__sdu_defense_place_tl` | tl | `defensePlace` | — |

#### 样式组变量

| 变量 | 类型 | 对应键 | 默认值 |
|------|------|--------|--------|
| `\l__sdu_line_spread_dim` | dim | `lineSpread` | `1.5` |
| `\l__sdu_page_left_tl` | tl | `pageLeft` | `3cm` |
| `\l__sdu_page_right_tl` | tl | `pageRight` | `3cm` |
| `\l__sdu_page_top_tl` | tl | `pageTop` | `2.5cm` |
| `\l__sdu_page_bottom_tl` | tl | `pageBottom` | `2.5cm` |

#### 模块组变量

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

### 5.2 内核核心函数

#### `\SDUSetup` —— 用户配置命令

```latex
\NewDocumentCommand \SDUSetup { m } { \keys_set:nn { sdu } { #1 } }
```

- **入参**：键值对（如 `module = undergraduate, title = {xxx}`）
- **机制**：调用 l3keys 的 `\keys_set:nn` 将键值写入对应变量
- **调用时机**：用户在 `sdusetup.tex` 中调用，可在 `\GetTitle` 等之前定义（LaTeX 延迟展开）

#### `\sdu_load_module:` —— 模块加载器

内核核心函数，位于 [src/sduthesis.dtx](file:///workspace/src/sduthesis.dtx)，处理多模块组合加载与盲审回退：

1. 将 `module` 字符串按逗号拆分为序列
2. **扫描阶段**：判断是否含 `blindreview`、是否已有基础模块（`undergraduate`/`master`）
3. **盲审回退**：若含 `blindreview` 但缺基础模块，前置加载 `sduthesis-undergraduate`
4. **正式加载**：按用户指定顺序依次 `\RequirePackage{sduthesis-<name>}`

通过 `\AddToHook{begindocument}` 在 `\begin{document}` 时触发，确保 `SDUSetup` 已被调用。

#### Getter 命令族

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

#### 盲审标志命令

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

### 5.3 Hook 系统

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

### 5.4 字体引擎

#### 字体选择策略

模板使用 TeX Live 自带的 **Fandol 开源中文字体**，保证 CI 和最小安装环境都能编译：

| 字体族 | 来源 | 大小 | TeX Live 自带 |
|--------|------|------|:---:|
| FandolSong/Hei/Kai | 开源 | ~15MB | ✅ |
| SimSun/SimHei/KaiTi | 商业 | ~30MB | ❌ |
| Noto CJK | 开源 | ~200MB | ❌ |

#### 字体加载机制

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

### 5.5 引用与交叉引用命令

| 命令 | 效果 | 实现 |
|------|------|------|
| `\citing{key}` | 上标数字引用 | `\let\citing\supercite` |
| `\citex{key}` | 括号引用 (Author, Year) | `\let\citex\citep` |
| `\figref{label}` | "图 X" | `\newcommand{\figref}[1]{图\ \ref{#1}\ }` |
| `\tabref{label}` | "表 X" | 类似 |
| `\equref{label}` | "式 X" | 类似 |
| `\subfigref{label}` | 子图引用 | 基于 `\subref*` |

### 5.6 章节引擎

通过 `\ctexset` 配置中文章节格式（命名 `第X章`），三级层次（chapter/section/subsection）：

| 层级 | 字号 | 字体 | 编号格式 |
|------|------|------|----------|
| chapter | 三号 | 黑体加粗 | 第一章（居中） |
| section | 四号 | 黑体加粗 | 1.1 |
| subsection | 小四号 | 黑体加粗 | 1.1.1 |

`secnumdepth=3` 控制编号深度，`fixskip=true` 修复 ctex 章节间距问题。

### 5.7 参考文献系统

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

---

## 6. 依赖关系

### 6.1 LaTeX 宏包依赖

内核在 [src/sduthesis.dtx](file:///workspace/src/sduthesis.dtx) 中 `\usepackage` 加载的宏包：

| 宏包 | 用途 |
|------|------|
| `expl3` + `l3keys2e` | LaTeX3 编程接口与键值系统 |
| `ctexbook` | 基础文档类（中文支持，作为 `\LoadClass` 加载） |
| `xeCJK` | CJK 字符处理 |
| `amsmath` / `amsthm` / `amsfonts` / `amssymb` / `unicode-math` | 数学排版 |
| `xcolor` | 颜色 |
| `geometry` | 页面尺寸 |
| `float` | 浮动体控制 |
| `fancyhdr` | 页眉页脚 |
| `setspace` | 行距 |
| `bookmark` | PDF 书签 |
| `booktabs` | 三线表 |
| `graphicx` | 图片 |
| `caption` / `subfig` | 图表标题与子图 |
| `listings` | 代码排版 |
| `tocloft` | 目录样式 |
| `biblatex` (biber, gb7714-2015) | 参考文献 |
| `hyperref` | 超链接 |
| `etoolbox` | 工具宏（`\AtBeginEnvironment` 等） |
| `tabularx` | 可变宽度表格 |
| `algorithmicx` / `algorithm` / `algpseudocode` | 算法排版 |

### 6.2 模块依赖关系

```
内核 sduthesis.cls
  ├── 加载 → ctexbook（基础文档类）
  ├── 加载 → 所有宏包（见 6.1）
  ├── 定义 → SDUSetup 引擎 + Hook 系统
  └── \AtBeginDocument 时调用 \sdu_load_module:
        │
        ├── 若含 blindreview 且无基础模块 → 前置加载 undergraduate
        │
        └── 按用户指定顺序加载：
            ├── sduthesis-undergraduate.sty （本科基础模块）
            │     └── 覆盖 \makecoverpage / cnabstract / ...
            │
            ├── sduthesis-master.sty （硕士基础模块）
            │     └── 覆盖 \makecoverpage / \makecommittee / ...
            │
            └── sduthesis-blindreview.sty （盲审叠加层，最后加载覆盖 Getter）
                  └── 覆盖 \GetAuthor → *** / \GetStudentId → *** / ...
```

**加载时序关键点**：
- 模块加载发生在 `\AtBeginDocument`（即 `\begin{document}` 时），早于 `main.tex` 中的任何排版命令
- 后加载的模块覆盖先加载的（盲审模块放最后，覆盖 Getter）
- 模块加载后触发 `sduthesis/after-setup` Hook

### 6.3 CI 依赖（TeX Live 包）

定义在 [.github/tl_packages](file:///workspace/.github/tl_packages)，按 collection 整组安装避免传递依赖遗漏：

| 类别 | 包 |
|------|-----|
| 编译基础 | `scheme-minimal`, `collection-latex`, `collection-xetex`, `latexmk`, `chktex`, `l3build` |
| 中文支持 | `ctex` |
| 参考文献 | `biber`, `biblatex`, `biblatex-gb7714-2015` |
| 模板使用 | `collection-latexextra`, `collection-latexrecommended`, `collection-fontsrecommended`, `collection-mathscience` |
| 独立包 | `algorithmicx` |
| 传递依赖 | `logreq`, `zhnumber` |

精简 lint 环境（[.github/tl_packages_lint](file:///workspace/.github/tl_packages_lint)）：`scheme-small` + `collection-binextra`（仅 chktex）。

### 6.4 构建工具依赖

| 工具 | 用途 | 安装 |
|------|------|------|
| `just` | 构建脚本执行器 | `brew install just` / `cargo install just` |
| `latexmk` | 自动化编译（Overleaf 同款） | TeX Live 自带 |
| `l3build` | LaTeX 包回归测试 | TeX Live 自带 |
| `chktex` | LaTeX 代码静态检查 | TeX Live 自带 |
| `xelatex` | 编译器 | TeX Live 自带 |
| `biber` | 参考文献处理器 | TeX Live 自带 |
| `git-cliff` | CHANGELOG 生成（release 用） | `taiki-e/install-action` |
| `python3` | 测试脚本 | 系统自带 |

---

## 7. 项目运行方式

### 7.1 环境要求

- **TeX Live** 2020 及以上版本（推荐 2024+）
- 或 **MacTeX** (macOS)
- 或 **Overleaf / TeXPage** 在线编辑

### 7.2 用户编译流程

#### 方式一：使用 `just`（推荐）

```bash
just build        # 编译 PDF（xelatex ×3 + biber）
just clean        # 清理辅助文件
just distclean    # 清理辅助文件和 PDF
just view         # 编译并打开 PDF（自动检测系统）
```

#### 方式二：使用 `latexmk`（Overleaf 同款流程）

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

#### 方式三：手动四次编译

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

### 7.3 用户配置流程

1. 修改 [sdusetup.tex](file:///workspace/sdusetup.tex) 中的 `\SDUSetup{}`：

```latex
\SDUSetup{
  module     = {undergraduate},    % 模块选择，支持逗号分隔多模块
  title      = {你的论文标题},
  author     = {你的姓名},
  studentId  = {你的学号},
  school     = {你的学院},
  major      = {你的专业},
  supervisor = {指导教师},
  year       = {2025},
  month      = {6},
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

### 7.4 在线编辑（Overleaf / TeXPage）

仓库根目录即为完整的在线编译模板：

- **Overleaf**：点击 README 顶部 "Open in Overleaf" 徽章（git 导入），或上传 `sduthesis-overleaf.zip`（由 `scripts/build-overleaf.sh` 生成）
- **TeXPage**：新建项目 → 上传仓库 zip

导入后务必设置：

| 设置项 | 值 |
|---|---|
| Compiler | **XeLaTeX** |
| Main document | `main.tex` |

### 7.5 开发者命令

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

#### 关键开发命令详解

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

### 7.6 打包发布命令

| 脚本 | 产物 | 用途 |
|------|------|------|
| `just tds` | `sduthesis.tds.zip` | TDS 格式包（可 `tlmgr install`） |
| `just ctan` | `sduthesis-ctan.zip` | CTAN 标准发布包 |
| `bash scripts/build-ctan.sh` | `sduthesis-ctan.zip` | CTAN 提交包（补纯文本 README + 自检） |
| `bash scripts/build-overleaf.sh` | `sduthesis-overleaf.zip` | Overleaf/TeXPage 在线模板包（含编译自检） |

---

## 8. 测试体系

### 8.1 测试分层

```
tests/test-compile.py       ← 完整编译测试（xelatex → biber → xelatex×2）
                                检查项：编译成功 + PDF 非空 + 日志无严重错误 + 引用无 ??
testfiles/*.tex + *.tlg     ← l3build 回归测试（输出对比基线，防回归）
```

### 8.2 `tests/test-compile.py` —— 编译冒烟测试

Python 脚本，运行 `just test` 触发，覆盖四项检查：

| 步骤 | 检查内容 |
|------|----------|
| 1. 编译 | xelatex → biber → xelatex × 2 四次编译是否成功 |
| 2. PDF | `main.pdf` 是否存在且非空（>1000 bytes） |
| 3. 日志 | `main.log` 中是否有 `Undefined control sequence` / `Missing` / `LaTeX Error` / `Emergency stop` / `Font error` |
| 4. 引用 | 是否有 `Citation undefined`（参考文献未解析，会显示 `??`） |

### 8.3 `testfiles/` —— l3build 回归测试

测试用例使用 `.tex` 扩展名（非 l3build 默认 `.lvt`，通过 `build.lua` 的 `lvtext = ".tex"` 配置）：

| 测试文件 | 测试内容 |
|----------|----------|
| `cover.tex` | 本科封面排版 |
| `abstract.tex` | 中英文摘要环境 |
| `toc.tex` | 目录生成 |
| `bib.tex` | 参考文献引用（`\citing` + `\printbib`） |
| `appendix.tex` | 附录编号（A/B/C）与"无空白页"行为（守护历史 bug PR #12） |
| `master.tex` | 硕士封面 + 答辩委员会页 |
| `blindreview.tex` | 本科 + 盲审组合（隐私断言） |
| `master-blindreview.tex` | 硕士 + 盲审组合（隐私断言） |

#### 测试机制

```latex
% testfiles/cover.tex 示例
\documentclass{sduthesis}
\input{setup-test}        % 公共配置（testfiles/support/setup-test.tex）
\input{regression-test}   % l3build 测试框架（提供 \START \END \ASSERT \TYPE）

\begin{document}
\START
\makecoverpage
\END
\end{document}
```

- `testfiles/support/setup-test.tex`：所有测试共用的 `\SDUSetup{}` 配置
- 每个 `.tex` 编译后产生输出，与同名 `.tlg` 基线对比
- `.tlg` 是回归基线，**提交到仓库后 `l3build check` 才真正生效**

#### 盲审测试的断言式校验

[testfiles/blindreview.tex](file:///workspace/testfiles/blindreview.tex) 通过 `\ASSERT` 显式断言隐私保护：

```latex
\ASSERT{\GetAuthor}{***}          % Getter 必须被掩码
\ASSERT{\GetStudentId}{***}
\ASSERT{\GetSupervisor}{***}
% 封面个人信息行在盲审模式下必须为空（行宽检测）
\setbox0=\hbox{\IfBlindReviewF{姓名:张某某 学号:202100100001 导师:李某某}}
\ifdim\wd0=0pt \TYPE{personal-row-hidden=YES}\else\TYPE{personal-row-hidden=NO}\fi
```

### 8.4 l3build 配置（[build.lua](file:///workspace/build.lua)）

```lua
module = "sduthesis"
supportdir = "./testfiles/support"
sourcefiles = {"src/*.dtx", "src/*.ins"}
unpackdir = "./build/unpacked"
-- 通过 tdsdirs 暴露模板依赖给隔离的测试目录
tdsdirs = {
  ["./modules"]         = "tex/latex/sduthesis",
  ["./build/unpacked"]  = "tex/latex/sduthesis",
  ["./figures"]         = "tex/latex/sduthesis/figures",
}
checkengines = {"xetex"}    -- 只测 XeTeX 引擎
checkopts = "-file-line-error -halt-on-error -interaction=nonstopmode"
lvtext = ".tex"             -- 测试文件用 .tex 扩展名
```

### 8.5 回归门禁策略

由 [scripts/l3build-check.sh](file:///workspace/scripts/l3build-check.sh) 实现，区分 push / pr 两种触发事件：

| 场景 | 行为 |
|------|------|
| 测试已有 `.tlg` 基线 | `l3build check` 对比输出，有差异则失败 |
| 测试缺失基线（PR 场景） | `l3build save` 生成基线并上传 artifact，**放行**（便于贡献者首次引入基线） |
| 测试缺失基线（push 到 develop） | `l3build save` 后**硬失败**，强制提醒提交基线 |

关键约束：
- `set -euo pipefail` 保证 l3build 失败时 job 真正失败（不被管道吞掉退出码）
- 对 `save` 单独容错：PR 场景 `save` 失败也放行，push 场景硬失败

---

## 9. CI/CD 流水线

### 9.1 GitHub Actions 三段式

| Workflow | 文件 | 职责 | 触发 |
|----------|------|------|------|
| **Quality** | [.github/workflows/quality.yml](file:///workspace/.github/workflows/quality.yml) | 代码质量：chktex lint（精简环境）+ 编译回归（test-compile + l3build） | PR / push develop，仅代码路径 |
| **Build** | [.github/workflows/build.yml](file:///workspace/.github/workflows/build.yml) | 构建 PDF 包（main.pdf artifact，TeX Live 2025/2026 双版本矩阵） | push main / 手动 |
| **Release** | [.github/workflows/release.yml](file:///workspace/.github/workflows/release.yml) | tag 发布（zip/TDS/CTAN + CHANGELOG） | tag `v*` |
| **Sync-CNB** | [.github/workflows/sync-cnb.yml](file:///workspace/.github/workflows/sync-cnb.yml) | GitHub → CNB 反向同步 | push main，仅模板代码路径 |

### 9.2 Quality Workflow

```
checkout
  ├── lint job（精简环境，约 1 分钟）
  │     ├── install-texlive（tl_packages_lint，仅 chktex）
  │     └── chktex -q sduthesis.cls modules/*.sty sdusetup.tex
  │
  └── regression job（完整环境）
        ├── install-texlive（tl_packages）
        ├── link fonts（XeTeX 字体目录符号链接）
        ├── install just
        ├── gen cls（从 DTX 提取）
        ├── python3 tests/test-compile.py（编译 + 检查）
        ├── bash scripts/l3build-check.sh ${{ github.event_name }}（回归门禁）
        └── upload-artifact: l3build-tlg（缺失基线时上传）
```

**lint 关键约定**：
- 排除规则固化在 [.chktexrc](file:///workspace/.chktexrc)（CmdLine 块），本地与 CI 行为一致
- 有 warning 即 CI 失败（gate），**不要用 `|| true` 绕过**
- 范围：只检查模板代码（`cls` / `modules/*.sty` / `sdusetup.tex`），**不检查 `main.tex`**（避免递归 `\input` 到 `data/` 对用户内容做 gate）

**chktex 排除规则**（`.chktexrc`）：

| 规则 | 说明 | 排除原因 |
|------|------|----------|
| `-n 1` | 命令后跟空格 | — |
| `-n 6` | 斜体修正缺失 | 字体声明宏（`\songti\itshape`）误报 |
| `-n 8` | 连字符长度 | `gb7714-2015`、参考文献页码合法用法 |
| `-n 13` | 句间空格 | — |
| `-n 24` | 删除多余空格 | `\left` / `\right` 后空格误报 |
| `-n 26` | 标点前空格 | expl3 l3keys 属性列表对齐空格误报 |
| `-n 36` | 其他已知误报 | — |

### 9.3 Build Workflow

```
checkout
  └── matrix（TeX Live 2025 + 2026）
        ├── install-texlive（显式指定与版本匹配的镜像）
        ├── link fonts
        ├── install just
        ├── gen cls
        ├── just build
        ├── verify PDF（test -s main.pdf）
        └── upload-artifact: main.pdf (TeX Live <version>)
```

**TeX Live 矩阵配置（关键）**：

| 版本 | repository | 说明 |
|------|------------|------|
| 2026 | `https://mirrors.mit.edu/CTAN/systems/texlive/tlnet/` | MIT 镜像（当前版） |
| 2025 | `https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2025/tlnet-final/` | 历史版 |

**关键决策**：仅 `build.yml` 矩阵显式指定镜像以确定性验证旧版本；`quality.yml` / `release.yml` 不传 `repository`，由 action 自动从官方镜像列表选（USA Alive 优先、按镜像 revision 缓存，长期命中）。

### 9.4 Release Workflow

```
checkout（fetch-tags）
  ├── install-texlive
  ├── link fonts
  ├── install just + git-cliff
  ├── gen cls
  ├── just build
  ├── just doc
  ├── git-cliff --config cliff.toml --output CHANGELOG.md
  ├── commit + push CHANGELOG.md [skip ci]
  ├── create zip archive（main.tex + sdusetup.tex + cls + modules + data + figures + 文档）
  ├── just tds（创建 TDS 包）
  └── softprops/action-gh-release（上传 main.pdf / sduthesis.zip / sduthesis.tds.zip / sduthesis-doc.pdf）
```

**关键约束**：`CHANGELOG.md` 不在任何 workflow 的触发 `paths` 中（避免 release push CHANGELOG 触发连锁 CI）。

### 9.5 CNB 流水线（[.cnb.yml](file:///workspace/.cnb.yml)）

CNB（cnb.cool）平台的原生流水线，与 GitHub 形成双向同步：

| 事件 | 流水线 | 行为 |
|------|--------|------|
| `main.push` | `sync-to-github` | CNB → GitHub 同步（`sync_mode: rebase`，保留 GitHub 平台文件） |
| `pull_request` | `auto-assign-pr-owner` | PR 创建后自动分配处理人 + 审查人 |
| `$.web_trigger_pull_from_github` | `web-trigger-pull-from-github` | 手动触发：GitHub → CNB 拉取（`sync_mode: pull`） |
| `$.issue.open` | `auto-assign-issue-owner` | Issue 创建后自动分配处理人（cnb-cli） |
| `$.tag_push` | `release-sduthesis` | tag 发布：texlive 镜像编译 + `git:release` + 附件上传 |

**防同步环**：`sync-cnb.yml` 的 paths 排除 `.cnb*` / `.cnb/` / `.github/**`，避免 GitHub↔CNB 相互推送造成死循环。

### 9.6 路径过滤设计

三个 workflow 的 paths 各自维护（GitHub Actions 不支持跨文件复用）：

| 路径 | quality.yml | build.yml | sync-cnb.yml |
|------|:---:|:---:|:---:|
| `src/**` `modules/**` `*.cls` `*.sty` `*.dtx` `*.ins` `*.tex` | ✅ | ✅ | ✅ |
| `testfiles/**` `tests/**` `.chktexrc` | ✅ | ❌ | ✅ |
| `justfile` | ✅ | ✅ | ✅ |
| `.github/tl_packages*` | ✅ | ✅（仅 `tl_packages`） | ❌（被 `.github/**` 排除） |
| workflow 自身文件 | ✅ | ✅ | ❌ |
| `README.md` | ❌ | ❌ | ✅ |
| `CHANGELOG.md` | ❌ | ❌ | ❌（防连锁） |

**设计意图**：
- `quality.yml` 是**最全**的一份（含测试与 lint 配置）
- `build.yml` **有意不含**测试路径（测试改动不影响构建产物）
- `sync-cnb.yml` 与 `quality.yml` 对齐（改 GitHub 后回灌 CNB 保持测试同步）

### 9.7 concurrency 与缓存

- **concurrency**：每个 workflow 设置 `cancel-in-progress: true`，连续 push 自动取消旧运行
- **TeX Live 缓存**：`zauguin/install-texlive@v4` 默认自动缓存 `~/texlive`，跨 workflow 复用；改包列表 `tl_packages` / `tl_packages_lint` 会自然导致缓存失效重建

---

## 10. 开发指南

### 10.1 开发流程

参考 [ROADMAP.md](file:///workspace/doc/ROADMAP.md) 的 Git 工作流：

```
1. 从 develop 切特性分支
   git checkout -b feat/your-feature develop

2. 开发 + 本地测试
   just gen       # 修改 DTX 后重新生成 cls
   just build     # 确保能编译
   just lint      # chktex 检查（与 CI 一致）
   just test      # 运行编译测试

3. 推送并创建 PR → develop
   git push origin feat/your-feature

4. CI 自动检查（quality.yml: lint + 回归）
5. Code review
6. 合并到 develop
7. 发版时 develop → main，打 tag 触发 release
```

### 10.2 分支命名规范

| 类型 | 格式 | 示例 |
|------|------|------|
| 功能 | `feat/<描述>` | `feat/hook-system` |
| 修复 | `fix/<描述>` | `fix/coverpage-alignment` |
| 文档 | `docs/<描述>` | `docs/user-manual` |
| 重构 | `refactor/<描述>` | `refactor/plugin-arch` |
| 发布 | `release/v<版本>` | `release/v1.2.0` |
| 热修 | `hotfix/v<版本>` | `hotfix/v1.1.1` |

### 10.3 提交信息规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/)：

```
<type>(<scope>): <subject>

<body>

<footer>
```

| type | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | 修复 |
| `docs` | 文档 |
| `refactor` | 重构（不改变外部行为） |
| `test` | 测试 |
| `ci` | CI/CD |
| `chore` | 构建/工具 |

### 10.4 如何添加新的 SDUSetup 键

以添加 `abstractCn` 键为例，四步流程（详见 [doc/DEVELOP.md](file:///workspace/doc/DEVELOP.md)）：

**第 1 步：声明变量（存储层）** —— 在 [src/sduthesis.dtx](file:///workspace/src/sduthesis.dtx) 的 `\ExplSyntaxOn` 区域：

```latex
\tl_new:N \l__sdu_abstract_cn_tl    % 命名规范：\l__sdu_<键名>_tl
```

**第 2 步：注册键（定义层）** —— 在 `\keys_define:nn { sdu }` 中：

```latex
\keys_define:nn { sdu } {
  abstractCn   .tl_set:N = \l__sdu_abstract_cn_tl,
  abstractCn   .initial:n = { },    % 可选：默认值
}
```

**第 3 步：导出 Getter（导出层）**：

```latex
\NewDocumentCommand \GetAbstractCn { } { \l__sdu_abstract_cn_tl }
```

**第 4 步：在模块中使用** —— 模块通过 Getter 获取值：

```latex
\renewenvironment{cnabstract}{ \GetAbstractCn }{}
```

> 完成后运行 `just gen` 重新生成 `sduthesis.cls`。

### 10.5 如何创建新模块

参考 [doc/DEVELOP.md](file:///workspace/doc/DEVELOP.md) 与现有模块：

1. 创建 `modules/sduthesis-<name>.sty`
2. 用 `\renewcommand` / `\renewenvironment` 覆盖封面和环境（**不是** `\newcommand`，因为内核已定义空实现）
3. 用 `\AddToHook` 在文档阶段注入页眉页脚和章节格式
4. 用 `\keys_define:nn { sdu }` 注册模块特有的配置键（如需）
5. 用户通过 `\SDUSetup{module=<name>}` 加载

模块模板：

```latex
\ProvidesPackage{sduthesis-<name>}[YYYY/MM/DD vX.Y.Z SDUThesis <name> module]

% 1. 覆盖封面
\renewcommand{\makecoverpage}{ ... }

% 2. 覆盖摘要环境
\renewenvironment{cnabstract}{ ... }{ ... }

% 3. 通过 Hook 注入页眉页脚
\AddToHook{sduthesis/mainmatter/begin}{
  \fancypagestyle{plain}{ ... }
  \pagestyle{plain}
}

\endinput
```

### 10.6 LaTeX3 命名规范

| 类型 | 格式 | 示例 |
|------|------|------|
| 内部变量 | `\l__sdu_<name>_<type>` | `\l__sdu_title_tl` |
| 内部函数 | `\sdu_<name>:` | `\sdu_load_module:` |
| 用户命令 | `\CamelCase` | `\SDUSetup`、`\GetTitle` |
| 变量类型后缀 | `_tl`（token list）/ `_dim`（dimension）/ `_seq`（序列）/ `_bool`（布尔） | — |

### 10.7 关键约束

1. **LaTeX3 函数必须在 `\ExplSyntaxOn` 区域内调用**，包括 `\AddToHook` 中的回调
2. **`\renewcommand` 而非 `\newcommand`** —— 内核已定义空实现，模块覆盖
3. **模块加载时序** —— 模块在 `\begin{document}` 时加载（通过 `\AddToHook{begindocument}`），早于 `main.tex` 中的任何排版命令
4. **修改 DTX 后必须 `just gen`** —— 不要手动编辑 `sduthesis.cls`
5. **新增 lint 排除规则前** —— 必须本地跑 `chktex -q sduthesis.cls modules/*.sty sdusetup.tex` 验证零 warning
6. **新增测试必须提交 `.tlg` 基线** —— 否则 push 到 develop 会硬失败
7. **附录必须在 `\backmatter` 之前** —— `\appendix` 依赖 `\@mainmattertrue` 才能生成"附录A/B/C"编号（历史 bug PR #12）

### 10.8 VS Code 集成

[.vscode/tasks.json](file:///workspace/.vscode/tasks.json) 提供常用构建任务：

- 编译论文（xelatex）
- 编译参考文献（biber）
- 完整编译（推荐）：`xelatex main.tex && biber main && xelatex main.tex && xelatex main.tex`
- 使用 latexmk 编译
- 清理临时文件
- 查看 PDF（依赖 LaTeX Workshop 扩展）

---

## 11. 设计决策记录

| 决策 | 选择 | 原因 |
|------|------|------|
| 配置机制 | l3keys | LaTeX3 标准，支持分组、默认值、类型检查 |
| 架构 | 内核 + 模块 | 解耦论文类型，方便扩展 |
| 扩展机制 | `\NewHook` / `\AddToHook` | LaTeX3 标准钩子，比 `\AtBeginDocument` 更精确 |
| 字体 | Fandol | TeX Live 自带，CI 和最小安装环境都能用 |
| 参考文献样式 | `gb7714-2015` | 符合国标 GB/T 7714-2015 |
| 参考文献后端 | biber（非 bibtex） | biblatex 是趋势，biber 是其原生后端 |
| 构建工具 | just | 比 Make 语法更简洁，跨平台 |
| DTX 格式 | docstrip | LaTeX 社区标准，CTAN 发布就绪 |
| 编译器 | XeLaTeX | 完美支持中文与 Unicode |
| 盲审回退位置 | 内核加载器（非盲审模块） | 与书写顺序无关，避免耦合 |
| 测试基线 | `.tlg` 提交到仓库 | `l3build check` 才真正生效，缺失时 PR 放行、push 硬失败 |
| TeX Live 缓存 | 不显式传 `repository`（quality/release） | 自动选择镜像，长期命中缓存 |
| TeX Live 矩阵 | 显式指定镜像（build） | 确定性验证旧版本兼容性 |
| lint 范围 | 不检查 `main.tex` | 避免递归 `\input` 到 `data/`，模板 CI 不对用户内容做 gate |
| 版本协议 | LPPL-1.3c | LaTeX 社区标准协议 |

---

## 附录：关键文件速查

| 文件 | 一句话说明 | 文档链接 |
|------|-----------|----------|
| [src/sduthesis.dtx](file:///workspace/src/sduthesis.dtx) | 内核源码 + 使用手册（DTX 格式） | [INTERNALS.md](file:///workspace/doc/INTERNALS.md) |
| [sduthesis.cls](file:///workspace/sduthesis.cls) | docstrip 生成的内核（不要手编） | — |
| [modules/sduthesis-undergraduate.sty](file:///workspace/modules/sduthesis-undergraduate.sty) | 本科论文模块 | — |
| [modules/sduthesis-master.sty](file:///workspace/modules/sduthesis-master.sty) | 硕士论文模块 | — |
| [modules/sduthesis-blindreview.sty](file:///workspace/modules/sduthesis-blindreview.sty) | 盲审叠加层模块 | — |
| [main.tex](file:///workspace/main.tex) | 编译入口 | — |
| [sdusetup.tex](file:///workspace/sdusetup.tex) | 用户配置 | — |
| [justfile](file:///workspace/justfile) | 构建脚本 | — |
| [build.lua](file:///workspace/build.lua) | l3build 配置 | — |
| [latexmkrc](file:///workspace/latexmkrc) | latexmk 配置（Overleaf 用） | [OVERLEAF.md](file:///workspace/doc/OVERLEAF.md) |
| [.chktexrc](file:///workspace/.chktexrc) | chktex lint 规则 | — |
| [tests/test-compile.py](file:///workspace/tests/test-compile.py) | 编译冒烟测试 | — |
| [scripts/l3build-check.sh](file:///workspace/scripts/l3build-check.sh) | 回归门禁逻辑 | — |
| [.github/workflows/quality.yml](file:///workspace/.github/workflows/quality.yml) | 代码质量 CI | [CI-TROUBLESHOOTING.md](file:///workspace/doc/CI-TROUBLESHOOTING.md) |
| [.github/workflows/build.yml](file:///workspace/.github/workflows/build.yml) | 构建 PDF CI | — |
| [.github/workflows/release.yml](file:///workspace/.github/workflows/release.yml) | 发布 CI | — |
| [.cnb.yml](file:///workspace/.cnb.yml) | CNB 流水线 | — |

---

*本文档由代码分析自动生成，基于仓库 v2.1.0 版本。如需了解最新实现，请直接阅读源码与 [doc/INTERNALS.md](file:///workspace/doc/INTERNALS.md)。*
