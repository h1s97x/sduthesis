\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sduthesis}[2025/05/16 v1.2.0 Thesis template for Shandong University]

% ============================================================
% 内核引擎：SDUSetup + Hook 系统 + 基础排版
% ============================================================

% 基于ctexbook的类
\LoadClass[openany]{ctexbook}

% -------------------- LaTeX3 引擎 --------------------
\RequirePackage{expl3}
\RequirePackage{l3keys2e}

\ExplSyntaxOn

% ==================== 存储层：变量声明 ====================
% --- 信息键 ---
\tl_new:N \l__sdu_title_tl
\tl_new:N \l__sdu_author_tl
\tl_new:N \l__sdu_studentid_tl
\tl_new:N \l__sdu_school_tl
\tl_new:N \l__sdu_major_tl
\tl_new:N \l__sdu_supervisor_tl
\tl_new:N \l__sdu_year_tl
\tl_new:N \l__sdu_month_tl

% --- 样式键 ---
\dim_new:N \l__sdu_line_spread_dim
\tl_new:N \l__sdu_page_left_tl
\tl_new:N \l__sdu_page_right_tl
\tl_new:N \l__sdu_page_top_tl
\tl_new:N \l__sdu_page_bottom_tl

% --- 模块键 ---
\tl_new:N \l__sdu_module_tl

% ==================== 定义层：键注册 ====================
\keys_define:nn { sdu }
{
  % --- 信息组 ---
  title       .tl_set:N = \l__sdu_title_tl,
  author      .tl_set:N = \l__sdu_author_tl,
  studentId   .tl_set:N = \l__sdu_studentid_tl,
  school      .tl_set:N = \l__sdu_school_tl,
  major       .tl_set:N = \l__sdu_major_tl,
  supervisor  .tl_set:N = \l__sdu_supervisor_tl,
  year        .tl_set:N = \l__sdu_year_tl,
  month       .tl_set:N = \l__sdu_month_tl,

  % --- 样式组 ---
  lineSpread  .tl_set:N = \l__sdu_line_spread_dim,
  lineSpread  .initial:n = { 1.5 },
  pageLeft    .tl_set:N = \l__sdu_page_left_tl,
  pageLeft    .initial:n = { 3cm },
  pageRight   .tl_set:N = \l__sdu_page_right_tl,
  pageRight   .initial:n = { 3cm },
  pageTop     .tl_set:N = \l__sdu_page_top_tl,
  pageTop     .initial:n = { 2.5cm },
  pageBottom  .tl_set:N = \l__sdu_page_bottom_tl,
  pageBottom  .initial:n = { 2.5cm },

  % --- 模块组 ---
  module      .tl_set:N = \l__sdu_module_tl,
  module      .initial:n = { undergraduate },
}

% ==================== 命令层：SDUSetup ====================
\NewDocumentCommand \SDUSetup { m }
{
  \keys_set:nn { sdu } { #1 }
}

% ==================== 导出层：Getter 命令 ====================
\NewDocumentCommand \GetTitle { } { \l__sdu_title_tl }
\NewDocumentCommand \GetAuthor { } { \l__sdu_author_tl }
\NewDocumentCommand \GetStudentId { } { \l__sdu_studentid_tl }
\NewDocumentCommand \GetSchool { } { \l__sdu_school_tl }
\NewDocumentCommand \GetMajor { } { \l__sdu_major_tl }
\NewDocumentCommand \GetSupervisor { } { \l__sdu_supervisor_tl }
\NewDocumentCommand \GetYear { } { \l__sdu_year_tl }
\NewDocumentCommand \GetMonth { } { \l__sdu_month_tl }

% ==================== 内部层：模块加载器 ====================
\NewDocumentCommand \sdu_load_module: { }
{
  % 构建模块包名
  \tl_set:Nx \l__sdu_module_pkg_tl { sduthesis-\l__sdu_module_tl }
  % 兼容 Overleaf：先检查 modules/ 目录，找到则拷贝到当前目录
  % 正常环境通过 TEXINPUTS 搜索 modules/ 目录
  \exp_args:Nx \file_if_exist:nT
    { modules/\l__sdu_module_pkg_tl .sty }
    {
      \file_copy:xx
        { modules/\l__sdu_module_pkg_tl .sty }
        { \l__sdu_module_pkg_tl .sty }
    }
  % 加载模块
  \exp_args:NV \RequirePackage \l__sdu_module_pkg_tl
}
\cs_generate_variant:Nn \file_copy:nn { xx }

\msg_new:nnn { sdu } { module-not-found }
{
  Module~'#1'~not~found.~Please~check~the~module~name~in~\SDUSetup.
}

% ==================== Hook 系统 ====================
% 内核在文档编译各阶段埋入钩子，模块通过钩子注入行为
\NewHook { sduthesis/after-setup }
\NewHook { sduthesis/before-cover }
\NewHook { sduthesis/cover-style }
\NewHook { sduthesis/frontmatter/begin }
\NewHook { sduthesis/mainmatter/begin }
\NewHook { sduthesis/backmatter/begin }

% 在 \begin{document} 时加载模块，确保 SDUSetup 已被调用
\AddToHook { begindocument } { \sdu_load_module: \UseHook { sduthesis/after-setup } }

\ExplSyntaxOff

% -------------------- 宏包加载 --------------------
\usepackage{amsmath}
\usepackage{amsthm}
\usepackage{amsfonts}
\usepackage{amssymb}
\usepackage{unicode-math}
\usepackage{xeCJK}
\usepackage{xcolor}
\usepackage{geometry}
\usepackage{float}
\usepackage{fancyhdr}
\usepackage{setspace}
\usepackage{bookmark}
\usepackage{booktabs}
\usepackage{graphicx}
\usepackage{caption}
\usepackage{listings}
\usepackage{tocloft}
\usepackage{subfig}
\usepackage[
    backend=biber,
    style=gb7714-2015,
    gbnamefmt=givenahead
]{biblatex}
\usepackage{hyperref}
\usepackage{etoolbox}
\usepackage{tabularx}
\usepackage{algorithmicx}
\usepackage{algorithm}
\usepackage{algpseudocode}

% -------------------- 算法设置 --------------------
\AtBeginEnvironment{algorithm}{\linespread{0.85}\selectfont}

% -------------------- 字体引擎 --------------------
\let\songti\relax
\let\heiti\relax
\let\kaiti\relax

\newCJKfontfamily\songti{FandolSong}
\newCJKfontfamily\heiti{FandolHei}
\newCJKfontfamily\kaiti{FandolKai}

\newcommand{\song}[1]{{\songti{#1}}}
\newcommand{\hei}[1]{{\heiti{#1}}}
\newcommand{\kai}[1]{{\kaiti{#1}}}

\newcommand{\bfsong}[1]{{\songti\textbf{#1}}}
\newcommand{\bfhei}[1]{{\heiti\textbf{#1}}}
\newcommand{\bfkai}[1]{{\kaiti\textbf{#1}}}
\newcommand{\itsong}[1]{{\songti\textit{#1}}}
\newcommand{\ithei}[1]{{\heiti\textit{#1}}}
\newcommand{\itkai}[1]{{\kaiti\textit{#1}}}
\newcommand{\bfitsong}[1]{{\songti\textbf{\textit{#1}}}}
\newcommand{\bfithei}[1]{{\heiti\textbf{\textit{#1}}}}
\newcommand{\bfitkai}[1]{{\kaiti\textbf{\textit{#1}}}}

\newcommand{\allbfsong}{\songti\bfseries}
\newcommand{\allbfhei}{\heiti\bfseries}
\newcommand{\allbfkai}{\kaiti\bfseries}
\newcommand{\allitsong}{\songti\itshape}
\newcommand{\allithei}{\heiti\itshape}
\newcommand{\allitkai}{\kaiti\itshape}
\newcommand{\allbfitsong}{\songti\bfseries\itshape}
\newcommand{\allbfithei}{\heiti\bfseries\itshape}
\newcommand{\allbfitkai}{\kaiti\bfseries\itshape}

% 英文字体：不显式指定，使用 LaTeX 默认（Computer Modern / Latin Modern）
% ctex 的 fandol 字体集已设置中文字体
% 如需自定义，用户可在 sdusetup.tex 中使用 \setmainfont 等命令

% 数学字体：unicode-math 默认使用 Latin Modern Math，无需显式指定

% 默认小四号宋体
\AtBeginDocument{\zihao{-4}\songti}

% 行距（使用 SDUSetup 中的配置）
\setstretch{1.5}

% -------------------- 页面引擎 --------------------
\geometry{
    a4paper,
    left=3cm,
    right=3cm,
    top=2.5cm,
    bottom=2.5cm,
}
\raggedbottom

% -------------------- 章节引擎 --------------------
\setcounter{secnumdepth}{3}

\ctexset{
    chapter={
      format=\centering\zihao{3}\allbfhei,
      name={第,章},
      beforeskip=21.6pt,
      afterskip=18pt,
      fixskip=true,
     },
    section={
      format=\zihao{4}\allbfhei,
      name={},
      beforeskip=18pt,
      afterskip=18pt,
      fixskip=true,
     },
    subsection={
      format=\zihao{-4}\allbfhei,
      name={},
      beforeskip=18pt,
      afterskip=18pt,
      fixskip=true,
    }
}

% -------------------- 交叉引用引擎 --------------------
\definecolor{linkdarkblue}{rgb}{0,0.08,0.45}

\hypersetup{
    colorlinks=true,
    linkcolor=black,
    citecolor=black,
    filecolor=black,
    urlcolor=linkdarkblue,
    bookmarksnumbered=true,
    pdfstartview=FitH,
}

\newcommand{\equref}[1]{式\ \eqref{#1}\ }
\newcommand{\tabref}[1]{表\ \ref{#1}\ }
\newcommand{\figref}[1]{图\ \ref{#1}\ }
\newcommand{\subfigref}[1]{{图\ \subref*{#1}\ }}
\let\citing\supercite
\let\citex\citep

% -------------------- 图表标题引擎 --------------------
\graphicspath{{figures/}}

\DeclareCaptionFont{mybfsong}{\allbfsong}
\DeclareCaptionFont{mywuhao}{\zihao{5}}
\DeclareSubrefFormat{mysubref}{#1(#2)}

\captionsetup[figure]{
    position=below,
    font={mywuhao,stretch=1.0},
    labelfont=mybfsong,
    textfont=mybfsong,
    labelsep=quad,
    margin=40pt,
    belowskip=-4pt,
}
\captionsetup[table]{
    position=above,
    font={mywuhao,stretch=1.0},
    labelfont=mybfsong,
    textfont=mybfsong,
    labelsep=quad,
    margin=40pt,
    belowskip=4pt,
}
\captionsetup[subfloat]{
    position=below,
    font={mywuhao,stretch=1.0},
    labelfont=mybfsong,
    textfont=mybfsong,
    subrefformat=mysubref,
}

% -------------------- 数学快捷命令 --------------------
\newcommand{\mye}{\ensuremath{\mathrm{e}}}
\newcommand{\myi}{\ensuremath{\mathrm{i}}}
\newcommand{\myj}{\ensuremath{\mathrm{j}}}

% -------------------- 代码排版引擎 --------------------
\lstset{
  belowskip=0pt,
  language=C++,
  basicstyle=\ttfamily\small,
  numbers=left,
  numberstyle=\tiny\color{gray},
  numbersep=5pt,
  breaklines=true,
  frame=single,
  rulecolor=\color{gray},
  framexleftmargin=1em,
  xleftmargin=2em,
  captionpos=b,
  showstringspaces=false,
  tabsize=4,
  columns=flexible,
  backgroundcolor=\color{gray!5},
  morekeywords={constexpr, nullptr, Ciphertext, Plaintext, vector, load_from_file, save_to_file}
}

% -------------------- 占位命令（由模块覆盖） --------------------
% 这些命令在 cls 中提供默认空实现，模块加载后会 \renewcommand 覆盖
\newcommand{\makecoverpage}{%
  \PackageWarning{sduthesis}{No~cover~page~defined.~Please~load~a~module~via~SDUSetup.}%
}

\newenvironment{cnabstract}{}{}
\newenvironment{enabstract}{}{}
\newcommand{\cnkeywords}[1]{}
\newcommand{\enkeywords}[1]{}

% -------------------- 通用环境定义 --------------------
% 这些是所有模块共享的基础环境，模块可以覆盖

% 参考文献
\addbibresource{data/ref/references.bib}
\renewcommand{\bibfont}{\zihao{5}}

\newcommand{\printbib}{
    \newpage
    \setstretch{1}
    \phantomsection
    \addcontentsline{toc}{chapter}{参考文献}
    \chapter*{参考文献}
    \printbibliography[heading=none]
}

% 致谢
\newenvironment{myacknowledgement}{
    \newpage
    \setstretch{1.5}
    \phantomsection
    \addcontentsline{toc}{chapter}{致谢}
    \chapter*{致\quad 谢}
    \zihao{-4}
}{
    \clearpage
}

% 附录
\newenvironment{myappendix}{
    \newpage
    \setstretch{1.5}
    \phantomsection
    \addcontentsline{toc}{chapter}{附录}
    \chapter*{附\quad 录}
    \zihao{-4}
    \appendix
    \renewcommand{\theequation}{A.\arabic{equation}}
    \renewcommand{\thetable}{A.\arabic{table}}
    \renewcommand{\thefigure}{A.\arabic{figure}}
}{
    \clearpage
}

% 目录
\newcommand{\maketable}{
    \renewcommand{\cleardoublepage}{\clearpage}
    \setcounter{page}{1}
    \fancypagestyle{plain}{
        \fancyhf{}
        \renewcommand{\thepage}{\Roman{page}}
        \renewcommand{\headrulewidth}{0pt}
        \fancyfoot[C]{\zihao{-5}\thepage}
    }
    \pagestyle{plain}

    \renewcommand{\contentsname}{目\quad 录}
    \renewcommand{\cfttoctitlefont}{\hfill\zihao{-2}}
    \renewcommand{\cftaftertoctitle}{\hfill}
    \renewcommand{\cftbeforetoctitleskip}{12pt}
    \renewcommand{\cftaftertoctitleskip}{12pt}
    \renewcommand{\cftdotsep}{1.5}
    \renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
    \setlength{\cftbeforechapskip}{0pt}

    \phantomsection
    \hypertarget{tableofcontent}{}
    \bookmark[dest=tableofcontent,level=0]{目录}
    \tableofcontents
}

\endinput
