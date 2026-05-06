# SDUThesis 技术文档

> 本文档面向开发者/维护者，记录项目架构、核心机制和设计决策。
> 面试准备时重点关注 **l3keys 机制**、**CI/CD 流水线**、**模板分层架构** 三个部分。

---

## 1. 项目概览

SDUThesis 是山东大学本科毕业论文 LaTeX 模板，基于 `ctexbook` 文档类，使用 XeLaTeX 编译引擎。

**技术栈**：LaTeX3 (expl3) + l3keys + XeLaTeX + biblatex + biber

**协议**：LPPL-1.3c (LaTeX Project Public License)

---

## 2. 核心架构：三层分离

```
用户只需关心这一层 ──→  data/          内容层（章节、摘要、参考文献）
                        sdusetup.tex   配置层（\SDUSetup{} 键值对）
用户不应修改这一层 ──→  config/        逻辑层（封面排版、环境定义、样式规则）
                        sduthesis.cls  入口（18行，加载所有 config）
```

设计原则：**用户修改 `data/` 和 `sdusetup.tex` 即可完成论文，永远不需要打开 `config/`**。

### 文件调用链

```
main.tex
  └→ \documentclass{sduthesis}
       └→ sduthesis.cls
            ├→ config/config-main.tex      ← SDUSetup 定义 + 宏包加载 + 全局设置
            ├→ config/config-coverpage.tex ← 封面排版逻辑
            ├→ config/config-abstract.tex  ← 摘要环境
            ├→ config/config-contents.tex  ← 目录格式
            ├→ config/config-bibliography.tex
            ├→ config/config-acknowledgement.tex
            └→ config/config-appendix.tex
  └→ \input{sdusetup.tex}                 ← 用户填写配置值
  └→ \begin{document}
       ├→ \frontmatter
       │    ├→ config/styles/style-frontmatter.tex  ← 页眉页脚为空
       │    ├→ data/frontmatter/coverpage.tex       ← \makecoverpage
       │    ├→ data/frontmatter/abstract.tex        ← 中文摘要 + 英文摘要
       │    └→ data/frontmatter/contents.tex        ← 目录
       ├→ \mainmatter
       │    ├→ config/styles/style-mainmatter.tex   ← 页眉页脚格式
       │    └→ data/chapters/chapter1-5.tex         ← 正文
       └→ \backmatter
            ├→ config/styles/style-backmatter.tex   ← 章标题格式调整
            ├→ data/frontmatter/bibliography.tex    ← \printbibliography
            ├→ data/frontmatter/acknowledgement.tex
            └→ data/frontmatter/appendix.tex
```

---

## 3. l3keys 键值配置机制（重点）

### 3.1 为什么用 l3keys？

传统 LaTeX 模板的配置方式是分散的：

```latex
% 旧方式：每个配置项单独定义命令，用户需要记住十几个命令
\newcommand{\Title}{xxx}
\newcommand{\Author}{xxx}
\newcommand{\School}{xxx}
```

l3keys 提供了统一的键值接口：

```latex
% 新方式：一个命令搞定所有配置
\SDUSetup{
  title = {xxx},
  author = {xxx},
  school = {xxx},
}
```

参考：BIThesis 的 `\BITSetup{}`，thuthesis 的 `\thusetup{}`，都是同样机制。

### 3.2 实现原理（三步链路）

**第一步：声明变量**（config-main.tex 第 13-20 行）

```latex
\ExplSyntaxOn
\tl_new:N \l__sdu_title_tl    % token list 变量，存储 title 值
\tl_new:N \l__sdu_author_tl
% ... 其他变量
```

- `\tl_new:N` — LaTeX3 的变量声明命令，`tl` = token list（标记列表）
- `\l__sdu_` 前缀 — LaTeX3 命名规范：`l` = local（局部变量），`__sdu` = 模块名，防止命名冲突
- `_tl` 后缀 — 变量类型标识（token list）

**第二步：定义键**（config-main.tex 第 23-32 行）

```latex
\keys_define:nn { sdu } {
  title      .tl_set:N = \l__sdu_title_tl,
  author     .tl_set:N = \l__sdu_author_tl,
  % ...
}
```

- `\keys_define:nn` — LaTeX3 的键定义命令，第一个参数 `{sdu}` 是模块名
- `.tl_set:N` — 属性处理器，表示"将用户输入的值存入指定的 token list 变量"
- 当用户写 `\SDUSetup{ title = {我的论文} }` 时，`{我的论文}` 会被存入 `\l__sdu_title_tl`

**第三步：定义用户命令 + 导出 Getter**（config-main.tex 第 35-47 行）

```latex
\NewDocumentCommand \SDUSetup { m } {
  \keys_set:nn { sdu } { #1 }
}

\NewDocumentCommand \GetTitle { } { \l__sdu_title_tl }
\NewDocumentCommand \GetAuthor { } { \l__sdu_author_tl }
```

- `\SDUSetup` — 用户接口命令，接收键值对，调用 `\keys_set:nn` 设置值
- `\GetTitle` — Getter 命令，展开为存储的值。封面代码中使用 `\GetTitle` 获取论文标题
- `\NewDocumentCommand` — LaTeX3 推荐的命令定义方式（替代 `\newcommand`）

### 3.3 数据流向

```
用户在 sdusetup.tex 中写入：
    \SDUSetup{ title = {基于深度学习的图像识别} }

    ↓ \keys_set:nn { sdu } { title = {基于深度学习的图像识别} }

    ↓ .tl_set:N 处理器

    ↓ \l__sdu_title_tl = {基于深度学习的图像识别}

封面排版时调用：
    \GetTitle → 展开 \l__sdu_title_tl → "基于深度学习的图像识别"
```

**关键点**：LaTeX 是延迟展开的。`\GetTitle` 在封面代码中只是被**定义**，不会立即展开。只有当 `\makecoverpage` 在 `\begin{document}` 之后被实际调用时，`\GetTitle` 才会展开取值。这保证了即使 `\SDUSetup` 在 `\makecoverpage` 之前调用，数据也能正确传递。

### 3.4 为什么不用 `\newcommand` 定义 Getter？

```latex
% ❌ 不推荐：每次调用都创建新的 token
\newcommand{\GetTitle}{基于深度学习的图像识别}

% ✅ 推荐：引用同一个变量，内存更高效，且可以被后续 \SDUSetup 覆盖
\NewDocumentCommand \GetTitle { } { \l__sdu_title_tl }
```

用变量方式，用户可以在文档中间修改配置值（虽然一般不需要），而且所有引用该值的地方自动更新。

---

## 4. 编译流程

### 4.1 为什么需要编译四次？

```
xelatex main.tex    ← 第1次：生成 .aux（引用信息）、.toc（目录）
biber main           ← 处理参考文献：.bcf → .bbl
xelatex main.tex    ← 第2次：插入参考文献和目录
xelatex main.tex    ← 第3次：解决交叉引用（图/表/公式编号）
```

一次编译无法完成的原因：
- 第1次编译时，引用目标还不存在（`图??`）
- biber 需要第1次编译生成的 `.bcf` 文件才知道要查哪些文献
- 第2次编译插入了参考文献，但页码可能变化
- 第3次编译确保所有交叉引用编号正确

### 4.2 justfile 中的实现

```just
build:
    #!/usr/bin/env bash
    set -e
    xelatex -synctex=1 -interaction=nonstopmode -halt-on-error main.tex
    biber main
    xelatex ... main.tex
    xelatex ... main.tex
```

- `-synctex=1`：生成 SyncTeX 数据，编辑器可以正反向搜索
- `-interaction=nonstopmode`：遇到错误不停，继续编译
- `-halt-on-error`：致命错误时停止

---

## 5. CI/CD 流水线

### 5.1 Build Workflow (build.yml)

**触发条件**：push 到 main / PR 到 main

```
checkout → 安装 TeX Live (setup-texlive-action@v4) → 安装 just → just build → 上传 PDF artifact
```

- `setup-texlive-action@v4`：按 `.github/tl_packages` 列表安装指定宏包，避免安装整个 TeX Live（4GB+）
- `tl_packages` 格式：逗号分隔的包名列表，支持 `collection-*` 组

### 5.2 Release Workflow (release.yml)

**触发条件**：推送 `v*` 格式的 tag

```
checkout → 安装 TeX Live → 安装 just + git-cliff → just build → 生成 changelog → 打包 ZIP → 创建 GitHub Release
```

- `git-cliff`：根据 `cliff.toml` 配置，从 git 提交历史自动生成 CHANGELOG.md
- ZIP 打包：只包含用户需要的文件（main.tex、config/、data/、cls、构建脚本）
- `softprops/action-gh-release@v2`：创建 GitHub Release 并上传 main.pdf + sduthesis.zip

### 5.3 并发控制

两个 workflow（build + release）可能同时 push 到 main（build 推送 PDF，release 推送 CHANGELOG），导致冲突。解决方案：release.yml 中使用 `git push` 时依赖 concurrency 控制。

---

## 6. 字体系统

### 6.1 为什么选 Fandol？

| 字体族 | 来源 | 大小 | 优点 | 缺点 |
|--------|------|------|------|------|
| **Fandol** | TeX Live 自带 | ~20MB | 零安装，CI 开箱即用 | 字符覆盖不如系统字体 |
| Noto CJK | Google 开源 | ~200MB | 字符覆盖全 | 需手动安装，CI 无法使用 |
| Windows 系统字体 | Windows 自带 | — | 效果最好 | Linux/Mac 没有 |

**设计决策**：模板默认用 Fandol 保证可移植性，用户可以在 `sdusetup.tex` 中覆盖为系统字体。

### 6.2 字体配置代码

```latex
% 先解除 ctex 对宋体/黑体/楷体的默认定义
\let\songti\relax
\let\heiti\relax
\let\kaiti\relax

% 重新定义为 Fandol 字体族
\newCJKfontfamily\songti{FandolSong}
\newCJKfontfamily\heiti{FandolHei}
\newCJKfontfamily\kaiti{FandolKai}
```

`\let\songti\relax` 是必要的——ctexbook 已经定义了 `\songti` 等命令，直接 `\newCJKfontfamily` 会报"命令已定义"错误。先 `\relax` 再重新定义。

### 6.3 字体命令体系

```latex
% 局部使用（带参数）
\song{文字}      % 宋体
\hei{文字}      % 黑体
\bfsong{文字}   % 加粗宋体

% 全局切换（不带参数，影响后续所有文字）
\allbfhei        % 切换为加粗黑体
```

### 6.4 英文字体

```latex
\setmainfont{TeX Gyre Termes}   % 衬线体（Times 替代）
\setsansfont{TeX Gyre Heros}    % 无衬线体（Helvetica 替代）
\setmonofont{TeX Gyre Cursor}   % 等宽体（Courier 替代）
\setmathfont{Latin Modern Math} % 数学字体
```

TeX Gyre 系列是开源字体，与商业字体（Times/Helvetica/Courier）metric 兼容，TeX Live 自带。

---

## 7. 参考文献系统

### 7.1 biblatex + biber + gb7714-2015

```latex
\usepackage[
    backend=biber,
    style=gb7714-2015,
    gbnamefmt=givenahead
]{biblatex}
```

- `backend=biber`：使用 biber 后端处理 UTF-8 BibTeX
- `style=gb7714-2015`：符合 GB/T 7714-2015 参考文献著录规则
- `gbnamefmt=givenahead`：姓名格式"名在前"（中文论文标准）

### 7.2 引用命令

```latex
\let\citing\supercite   % 上标引用 [1]
\let\citex\citep        % 括号引用 (Author, Year)
```

`\citing` 是用户接口命令，内部映射到 `\supercite`（上标数字引用）。如果将来要换引用风格，只需修改这一行映射。

---

## 8. 章节标题格式

```latex
\ctexset{
    chapter={
      format=\centering\zihao{3}\allbfhei,  % 居中、三号、加粗黑体
      name={第,章},                          % "第X章"
      beforeskip=21.6pt,
      afterskip=18pt,
      fixskip=true,
    },
    section={
      format=\zihao{4}\allbfhei,            % 四号、加粗黑体
    },
    subsection={
      format=\zihao{-4}\allbfhei,           % 小四号、加粗黑体
    }
}
```

`fixskip=true` 修复了 ctex 标题前后间距的不一致问题（标准 LaTeX 的 `\vspace` 会被列表环境吞掉）。

---

## 9. 页面样式三段式

论文分三段，每段页眉页脚不同：

| 阶段 | 页眉 | 页脚 | 文件 |
|------|------|------|------|
| 前言 (frontmatter) | 空 | 空 | style-frontmatter.tex |
| 正文 (mainmatter) | "山东大学本科毕业论文（设计）" | 页码 | style-mainmatter.tex |
| 后记 (backmatter) | 同正文 | 同正文 | style-backmatter.tex |

后记阶段额外调整了章节标题格式——参考文献、致谢等不编号章节使用小二号居中加粗。

---

## 10. 项目代码统计

| 类别 | 文件 | 行数 | 说明 |
|------|------|------|------|
| **模板入口** | sduthesis.cls | 18 | 加载所有 config |
| **核心逻辑** | config/config-main.tex | 285 | SDUSetup + 宏包 + 字体 + 格式 |
| **封面排版** | config/config-coverpage.tex | 60 | Logo + 信息表格 |
| **摘要环境** | config/config-abstract.tex | 41 | 中英文摘要 + 关键词 |
| **其他环境** | config/其余4个 | 80 | 目录/参考文献/致谢/附录 |
| **样式** | config/styles/ | 23 | 三段式页眉页脚 |
| **模板合计** | | **~507** | |
| 用户配置 | sdusetup.tex | 28 | |
| 用户内容 | data/ | 839 | |
| 构建 | justfile | 70 | |
| CI/CD | .github/workflows/ | 100 | |

---

## 11. v2.0.0 目标架构

### 文件树

```
sduthesis/
├── src/                          # 模板源码（DTX 格式）
│   ├── sduthesis.dtx             # 主源码：代码 + 文档注释
│   ├── sduthesis.ins             # 安装脚本：生成 .cls
│   └── sduthesis-doc.tex         # 使用手册源码
│
├── templates/                    # 用户模板（各学位类型）
│   ├── undergraduate/            # 本科生模板
│   │   ├── main.tex              # 文档骨架
│   │   ├── sdusetup.tex          # 用户配置
│   │   ├── data/                 # 论文内容
│   │   └── figures/              # 图片
│   ├── master/                   # 硕士模板（新增）
│   └── doctor/                   # 博士模板（新增）
│
├── tests/                        # 自动化测试
│   ├── test-compile.py           # 编译测试脚本
│   ├── test-diff.py              # PDF 回归测试
│   └── baseline/                 # 基线 PDF
│
├── doc/                          # 文档
│   ├── sduthesis-doc.pdf         # 使用手册（从 src/sduthesis-doc.tex 编译）
│   └── DEVELOP.md                # 开发者指南
│
├── .github/
│   ├── workflows/
│   │   ├── build.yml             # 编译验证
│   │   ├── test.yml              # 回归测试
│   │   └── release.yml           # CTAN 发布
│   ├── tl_packages
│   └── ISSUE_TEMPLATE/
│
├── justfile                      # 构建脚本
├── cliff.toml                    # changelog 配置
├── README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
└── LICENSE                       # LPPL-1.3c
```

### v1.x → v2.0 架构变化

| 方面 | v1.x (当前) | v2.0 |
|------|-------------|------|
| **源码格式** | `.cls` + `config/*.tex` | `.dtx` 单文件（代码+文档合一） |
| **配置接口** | `\SDUSetup{}` 8 个字段 | `\SDUSetup{}` 覆盖 cover/info/style/misc 分组 |
| **模板类型** | 仅本科生 | 本科 + 硕士 + 博士 |
| **测试** | 无 | PDF diff 回归 + 多版本 TeX Live 矩阵 |
| **分发** | GitHub Release | CTAN + TeX Live + Overleaf |
| **文档** | README + FAQ | sduthesis-doc.pdf 完整手册 |
| **安装** | clone 仓库 | `tlmgr install sduthesis` |

### DTX 格式说明

DTX (DocTeX) 是 LaTeX 社区的标准源码格式，一个 `.dtx` 文件同时包含：
- 代码（被 `%` 注释包裹，通过 `.ins` 文件提取为 `.cls`）
- 文档（宏包使用说明，编译为 PDF 手册）

```dtx
% \begin{macro}{\SDUSetup}
%   用户配置命令，接收键值对参数。
% \begin{syntax}
%   \SDUSetup{<key>=<value>, ...}
% \end{syntax}
% \end{macro}
%
%<*class>
\NewDocumentCommand \SDUSetup { m } {
  \keys_set:nn { sdu } { #1 }
}
%</class>
```

- `%<*class>...%</class>` 之间的内容会被提取到 `.cls` 文件
- 其余注释文本会被排版为 PDF 文档

**好处**：代码和文档永远同步，不会出现"文档说的接口和实际代码不一致"的问题。
