%%
%% This is file `sduthesis.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% sduthesis.dtx  (with options: `cls')
%% 
%% Copyright (C) 2025 h1s97x
%% 
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either
%% version 1.3c of this license or (at your option) any later
%% version. This version of this license is in
%%    https://www.latex-project.org/lppl/lppl-1-3c.txt
%% and the latest version of this license is in
%%    https://www.latex-project.org/lppl.txt
%% and version 1.3 or later is part of all distributions of
%% LaTeX version 2020/11/27 or later.
%% 
%% This work has the LPPL maintenance status "maintained".
%% 
%% The Current Maintainer of this work is h1s97x.
%% 
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sduthesis}[2026/08/18 v2.2.0 Thesis template for Shandong University]
\LoadClass[openany]{ctexbook}
\RequirePackage{expl3}
\RequirePackage{l3keys2e}

\ExplSyntaxOn
\tl_new:N \l__sdu_title_tl
\tl_new:N \l__sdu_author_tl
\tl_new:N \l__sdu_studentid_tl
\tl_new:N \l__sdu_school_tl
\tl_new:N \l__sdu_major_tl
\tl_new:N \l__sdu_supervisor_tl
\tl_new:N \l__sdu_year_tl
\tl_new:N \l__sdu_month_tl
\tl_new:N \l__sdu_degree_tl
\tl_new:N \l__sdu_committee_chair_tl
\tl_new:N \l__sdu_committee_members_tl
\tl_new:N \l__sdu_defense_date_tl
\tl_new:N \l__sdu_defense_place_tl
\dim_new:N \l__sdu_line_spread_dim
\tl_new:N \l__sdu_page_left_tl
\tl_new:N \l__sdu_page_right_tl
\tl_new:N \l__sdu_page_top_tl
\tl_new:N \l__sdu_page_bottom_tl
\tl_new:N \l__sdu_module_tl
\seq_new:N \l__sdu_module_seq
\tl_new:N \l__sdu_module_tmp_tl
\tl_new:N \l__sdu_module_item_tl
\tl_new:N \l__sdu_module_pkg_tl
\bool_new:N \l__sdu_blindreview_bool
\bool_new:N \l__sdu_has_blindreview_bool
\bool_new:N \l__sdu_has_base_module_bool
\keys_define:nn { sdu / info }
{
  title          .tl_set:N = \l__sdu_title_tl,
  author         .tl_set:N = \l__sdu_author_tl,
  studentId      .tl_set:N = \l__sdu_studentid_tl,
  school         .tl_set:N = \l__sdu_school_tl,
  major          .tl_set:N = \l__sdu_major_tl,
  supervisor     .tl_set:N = \l__sdu_supervisor_tl,
  year           .tl_set:N = \l__sdu_year_tl,
  month          .tl_set:N = \l__sdu_month_tl,
  degree         .tl_set:N = \l__sdu_degree_tl,
  degree         .initial:n = { 硕士 },
  committeeChair .tl_set:N = \l__sdu_committee_chair_tl,
  committeeMembers .tl_set:N = \l__sdu_committee_members_tl,
  defenseDate    .tl_set:N = \l__sdu_defense_date_tl,
  defensePlace   .tl_set:N = \l__sdu_defense_place_tl,
}

\keys_define:nn { sdu / option }
{
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
}

\keys_define:nn { sdu }
{
  % 顶层：模块键 + info/option 嵌套代理键
  module   .tl_set:N = \l__sdu_module_tl,
  module   .initial:n = { undergraduate },
  info     .code:n = { \keys_set:nn { sdu / info } { #1 } },
  option   .code:n = { \keys_set:nn { sdu / option } { #1 } },

  % 平铺兼容别名：保持旧写法的键仍可在顶层直接使用
  title          .tl_set:N = \l__sdu_title_tl,
  author         .tl_set:N = \l__sdu_author_tl,
  studentId      .tl_set:N = \l__sdu_studentid_tl,
  school         .tl_set:N = \l__sdu_school_tl,
  major          .tl_set:N = \l__sdu_major_tl,
  supervisor     .tl_set:N = \l__sdu_supervisor_tl,
  year           .tl_set:N = \l__sdu_year_tl,
  month          .tl_set:N = \l__sdu_month_tl,
  degree         .tl_set:N = \l__sdu_degree_tl,
  committeeChair .tl_set:N = \l__sdu_committee_chair_tl,
  committeeMembers .tl_set:N = \l__sdu_committee_members_tl,
  defenseDate    .tl_set:N = \l__sdu_defense_date_tl,
  defensePlace   .tl_set:N = \l__sdu_defense_place_tl,
  lineSpread     .tl_set:N = \l__sdu_line_spread_dim,
  pageLeft       .tl_set:N = \l__sdu_page_left_tl,
  pageRight      .tl_set:N = \l__sdu_page_right_tl,
  pageTop        .tl_set:N = \l__sdu_page_top_tl,
  pageBottom     .tl_set:N = \l__sdu_page_bottom_tl,
}
\NewDocumentCommand \SDUSetup { m }
{
  \keys_set:nn { sdu } { #1 }
}
\NewDocumentCommand \GetTitle { } { \l__sdu_title_tl }
\NewDocumentCommand \GetAuthor { } { \l__sdu_author_tl }
\NewDocumentCommand \GetStudentId { } { \l__sdu_studentid_tl }
\NewDocumentCommand \GetSchool { } { \l__sdu_school_tl }
\NewDocumentCommand \GetMajor { } { \l__sdu_major_tl }
\NewDocumentCommand \GetSupervisor { } { \l__sdu_supervisor_tl }
\NewDocumentCommand \GetYear { } { \l__sdu_year_tl }
\NewDocumentCommand \GetMonth { } { \l__sdu_month_tl }
\NewDocumentCommand \GetDegree { } { \l__sdu_degree_tl }
\NewDocumentCommand \GetCommitteeChair { } { \l__sdu_committee_chair_tl }
\NewDocumentCommand \GetCommitteeMembers { } { \l__sdu_committee_members_tl }
\NewDocumentCommand \GetDefenseDate { } { \l__sdu_defense_date_tl }
\NewDocumentCommand \GetDefensePlace { } { \l__sdu_defense_place_tl }
\ExplSyntaxOff
\makeatletter
\IfFileExists{modules/sduthesis-undergraduate.sty}{%
  \ifx\input@path\@undefined
    \def\input@path{{modules/}}%
  \else
    \g@addto@macro\input@path{{modules/}}%
  \fi
  \typeout{sduthesis: added modules/ to search path}%
}{}
\makeatother
\ExplSyntaxOn
\msg_new:nnn { sdu } { module-not-found }
{
  Module~'#1'~not~found.~Please~check~the~module~name~in~\SDUSetup.
}
\cs_new:Nn \sdu_load_module:
{
  \tl_set:Nx \l__sdu_module_tmp_tl { \l__sdu_module_tl }
  \seq_set_split:NnV \l__sdu_module_seq { , } \l__sdu_module_tmp_tl
  % 先扫描：判断是否含 blindreview、是否已有基础模块
  \bool_set_false:N \l__sdu_has_blindreview_bool
  \bool_set_false:N \l__sdu_has_base_module_bool
  \seq_map_inline:Nn \l__sdu_module_seq
  {
    \tl_set:Nx \l__sdu_module_item_tl { \tl_trim_spaces:n { ##1 } }
    \tl_if_eq:NnT \l__sdu_module_item_tl { blindreview }
      { \bool_set_true:N \l__sdu_has_blindreview_bool }
    \tl_if_eq:NnT \l__sdu_module_item_tl { undergraduate }
      { \bool_set_true:N \l__sdu_has_base_module_bool }
    \tl_if_eq:NnT \l__sdu_module_item_tl { master }
      { \bool_set_true:N \l__sdu_has_base_module_bool }
  }
  % 单独使用 blindreview 时前置加载本科模块（与书写顺序无关）
  \bool_if:NT \l__sdu_has_blindreview_bool
  {
    \bool_if:NF \l__sdu_has_base_module_bool
    {
      \RequirePackage{sduthesis-undergraduate}
    }
  }
  % 按用户指定顺序正式加载
  \seq_map_inline:Nn \l__sdu_module_seq
  {
    \tl_set:Nx \l__sdu_module_item_tl { \tl_trim_spaces:n { ##1 } }
    \tl_if_empty:NF \l__sdu_module_item_tl
    {
      \tl_set:Nx \l__sdu_module_pkg_tl { sduthesis-\l__sdu_module_item_tl }
      \exp_args:NV \RequirePackage \l__sdu_module_pkg_tl
    }
  }
}
\NewHook { sduthesis/after-setup }
\NewHook { sduthesis/before-cover }
\NewHook { sduthesis/cover-style }
\NewHook { sduthesis/frontmatter/begin }
\NewHook { sduthesis/mainmatter/begin }
\NewHook { sduthesis/backmatter/begin }
\AddToHook { begindocument } { \sdu_load_module: \UseHook { sduthesis/after-setup } }

\cs_new:Npn \IfBlindReviewTF #1 #2
{
  \bool_if:NTF \l__sdu_blindreview_bool { #1 } { #2 }
}
\cs_new:Npn \IfBlindReviewF #1
{
  \bool_if:NF \l__sdu_blindreview_bool { #1 }
}
\NewDocumentCommand \IfBlindReview { m m } { \IfBlindReviewTF { #1 } { #2 } }

\ExplSyntaxOff
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
\AtBeginEnvironment{algorithm}{\linespread{0.85}\selectfont}
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
\AtBeginDocument{\zihao{-4}\songti}
\setstretch{1.5}
\geometry{
    a4paper,
    left=3cm,
    right=3cm,
    top=2.5cm,
    bottom=2.5cm,
}
\raggedbottom
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
\newcommand{\mye}{\ensuremath{\mathrm{e}}}
\newcommand{\myi}{\ensuremath{\mathrm{i}}}
\newcommand{\myj}{\ensuremath{\mathrm{j}}}
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
  morekeywords={constexpr, nullptr, Ciphertext, Plaintext, vector,
    load_from_file, save_to_file}
}
\newcommand{\makecoverpage}{%
  \PackageWarning{sduthesis}{No~cover~page~defined.~Please~load~a~module~via~SDUSetup.}%
}
\newcommand{\makestatement}{%
  \PackageWarning{sduthesis}{No~statement~page~defined.~Please~load~a~module~via~SDUSetup.}%
}
\newcommand{\makecommittee}{%
  \PackageWarning{sduthesis}{No~committee~page~defined.~Please~load~a~module~via~SDUSetup.}%
}
\newenvironment{cnabstract}{}{}
\newenvironment{enabstract}{}{}
\newcommand{\cnkeywords}[1]{}
\newcommand{\enkeywords}[1]{}
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
\newenvironment{myappendix}{
    \newpage
    \setstretch{1.5}
    \phantomsection
    \appendix
    \zihao{-4}
    \renewcommand{\theequation}{\thechapter.\arabic{equation}}
    \renewcommand{\thetable}{\thechapter.\arabic{table}}
    \renewcommand{\thefigure}{\thechapter.\arabic{figure}}
}{
    \clearpage
}
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
%%
%% End of file `sduthesis.cls'.
