# 自定义指南

本指南提供了 SDU Thesis 模板的各种自定义方法，帮助用户根据特定需求调整模板样式和功能。

## 📋 目录

- [快速自定义](#快速自定义)
- [字体自定义](#字体自定义)
- [样式自定义](#样式自定义)
- [布局自定义](#布局自定义)
- [功能扩展](#功能扩展)
- [高级自定义](#高级自定义)

## 🚀 快速自定义

### 创建用户配置文件

1. **创建自定义配置目录**
   ```bash
   mkdir config/custom
   ```

2. **创建用户设置文件**
   ```latex
   % config/custom/user-settings.tex
   
   % 个人信息设置
   \Title{您的论文标题}
   \Author{您的姓名}
   \StudentID{202012345678}
   \Department{计算机科学与技术学院}
   \Major{计算机科学与技术}
   \Grade{2020级}
   \Teacher{导师姓名}
   
   % 自定义颜色
   \definecolor{myblue}{RGB}{0,102,204}
   \definecolor{mygreen}{RGB}{0,153,76}
   
   % 自定义命令
   \newcommand{\important}[1]{\textcolor{myblue}{\textbf{#1}}}
   \newcommand{\note}[1]{\textcolor{mygreen}{\textit{#1}}}
   ```

3. **在主文档中引入**
   ```latex
   % 在 main.tex 中添加
   \input{config/custom/user-settings.tex}
   ```

## 🔤 字体自定义

### 1. 添加新字体

#### 中文字体添加
```latex
% 添加方正字体
\newCJKfontfamily\fangsong[
    Path=assets/fonts/,
    AutoFakeBold=2,
    AutoFakeSlant=0.2
]{FZFangSong-Z02S.ttf}

% 添加华文字体
\newCJKfontfamily\huawen[
    Path=assets/fonts/,
    AutoFakeBold=3,
    AutoFakeSlant=0.25
]{STXihei.ttf}

% 定义使用命令
\newcommand{\fang}[1]{{\fangsong{#1}}}
\newcommand{\huawen}[1]{{\huawen{#1}}}
```

#### 英文字体添加
```latex
% 添加 Arial 字体
\newfontfamily\arial{Arial}
\newcommand{\textarial}[1]{{\arial{#1}}}

% 添加 Calibri 字体
\newfontfamily\calibri{Calibri}
\newcommand{\textcalibri}[1]{{\calibri{#1}}}
```

### 2. 字体大小自定义

```latex
% 定义自定义字号
\newcommand{\zihaoyi}{\fontsize{26pt}{31.2pt}\selectfont}    % 一号
\newcommand{\zihaoxiaoyi}{\fontsize{24pt}{28.8pt}\selectfont} % 小一号
\newcommand{\zihaoliu}{\fontsize{7.5pt}{9pt}\selectfont}     % 六号

% 使用示例
{\zihaoyi 这是一号字体}
{\zihaoxiaoyi 这是小一号字体}
```

### 3. 字体样式组合

```latex
% 定义组合样式
\newcommand{\titlefont}{\zihao{2}\bfhei}           % 标题字体
\newcommand{\subtitlefont}{\zihao{3}\kai}         % 副标题字体
\newcommand{\authorfont}{\zihao{4}\song}          % 作者字体
\newcommand{\datefont}{\zihao{-4}\kai}            % 日期字体

% 使用示例
{\titlefont 主标题}
{\subtitlefont 副标题}
{\authorfont 作者姓名}
{\datefont 2024年12月}
```

## 🎨 样式自定义

### 1. 颜色主题自定义

#### 定义颜色主题
```latex
% 蓝色主题
\definecolor{themeblue}{RGB}{0,102,204}
\definecolor{lightblue}{RGB}{173,216,230}
\definecolor{darkblue}{RGB}{0,51,102}

% 绿色主题
\definecolor{themegreen}{RGB}{0,153,76}
\definecolor{lightgreen}{RGB}{144,238,144}
\definecolor{darkgreen}{RGB}{0,100,0}

% 红色主题
\definecolor{themered}{RGB}{220,20,60}
\definecolor{lightred}{RGB}{255,182,193}
\definecolor{darkred}{RGB}{139,0,0}
```

#### 应用颜色主题
```latex
% 超链接颜色
\hypersetup{
    linkcolor=themeblue,
    citecolor=themegreen,
    urlcolor=themered,
}

% 章节标题颜色
\ctexset{
    chapter={
        format=\centering\zihao{3}\color{themeblue}\allbfhei,
    },
    section={
        format=\zihao{4}\color{darkblue}\allbfhei,
    }
}
```

### 2. 章节标题样式自定义

#### 现代简约风格
```latex
\ctexset{
    chapter={
        format=\raggedright\zihao{2}\bfseries,
        name={},
        number=\arabic{chapter},
        beforeskip=0pt,
        afterskip=30pt,
        fixskip=true,
    },
    section={
        format=\raggedright\zihao{3}\bfseries\color{themeblue},
        beforeskip=24pt,
        afterskip=12pt,
    }
}
```

#### 传统学术风格
```latex
\ctexset{
    chapter={
        format=\centering\zihao{-2}\allbfhei,
        name={第,章\quad},
        beforeskip=30pt,
        afterskip=24pt,
    },
    section={
        format=\zihao{-3}\allbfhei,
        name={\S\,},
        beforeskip=18pt,
        afterskip=12pt,
    }
}
```

### 3. 图表标题样式自定义

#### 简洁风格
```latex
\captionsetup[figure]{
    font=small,
    labelfont=bf,
    textfont=it,
    labelsep=period,
    justification=centering,
}

\captionsetup[table]{
    font=small,
    labelfont=bf,
    textfont=normal,
    labelsep=period,
    justification=centering,
}
```

#### 学术风格
```latex
\captionsetup[figure]{
    font={small,stretch=1.2},
    labelfont={bf,color=darkblue},
    textfont=normal,
    labelsep=colon,
    justification=justified,
    singlelinecheck=false,
}
```

## 📐 布局自定义

### 1. 页面布局调整

#### A4 标准布局
```latex
\geometry{
    a4paper,
    left=3cm,
    right=3cm,
    top=2.5cm,
    bottom=2.5cm,
    headheight=1.5cm,
    headsep=0.5cm,
    footskip=1cm,
}
```

#### 紧凑布局
```latex
\geometry{
    a4paper,
    left=2.5cm,
    right=2.5cm,
    top=2cm,
    bottom=2cm,
    headheight=1cm,
    headsep=0.3cm,
    footskip=0.8cm,
}
```

#### 宽松布局
```latex
\geometry{
    a4paper,
    left=3.5cm,
    right=3.5cm,
    top=3cm,
    bottom=3cm,
    headheight=2cm,
    headsep=0.8cm,
    footskip=1.2cm,
}
```

### 2. 页眉页脚自定义

#### 简洁页眉页脚
```latex
\fancypagestyle{main}{
    \fancyhf{}
    \fancyfoot[C]{\thepage}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
}
```

#### 详细页眉页脚
```latex
\fancypagestyle{main}{
    \fancyhf{}
    \fancyhead[L]{\small\leftmark}
    \fancyhead[R]{\small 山东大学本科毕业论文}
    \fancyfoot[L]{\small\@author}
    \fancyfoot[C]{\thepage}
    \fancyfoot[R]{\small\@date}
    \renewcommand{\headrulewidth}{0.4pt}
    \renewcommand{\footrulewidth}{0.4pt}
}
```

### 3. 目录样式自定义

#### 现代目录样式
```latex
% 目录标题
\renewcommand{\contentsname}{\huge\bfseries Contents}

% 章节样式
\renewcommand{\cftchapfont}{\large\bfseries\color{themeblue}}
\renewcommand{\cftsecfont}{\normalsize\color{darkblue}}
\renewcommand{\cftsubsecfont}{\small\color{gray}}

% 页码样式
\renewcommand{\cftchappagefont}{\large\bfseries\color{themeblue}}
\renewcommand{\cftsecpagefont}{\normalsize\color{darkblue}}

% 点线样式
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftdotsep}{2}
```

## 🔧 功能扩展

### 1. 自定义环境

#### 定理环境
```latex
% 定义定理样式
\newtheoremstyle{mythm}
    {12pt}        % 上方间距
    {12pt}        % 下方间距
    {\itshape}    % 正文字体
    {0pt}         % 缩进
    {\bfseries\color{themeblue}}  % 标题字体
    {.}           % 标题后标点
    {.5em}        % 标题后间距
    {}            % 标题格式

\theoremstyle{mythm}
\newtheorem{theorem}{定理}[chapter]
\newtheorem{lemma}[theorem]{引理}
\newtheorem{corollary}[theorem]{推论}
\newtheorem{definition}[theorem]{定义}
```

#### 示例环境
```latex
\newenvironment{example}[1][]{
    \par\medskip\noindent
    \textbf{\color{themegreen}示例%
    \if\relax\detokenize{#1}\relax\else\ (#1)\fi:}
    \rmfamily
}{
    \par\medskip
}
```

#### 注意事项环境
```latex
\newenvironment{notice}[1][注意]{
    \begin{tcolorbox}[
        colback=yellow!10,
        colframe=orange!80,
        title=#1,
        fonttitle=\bfseries,
    ]
}{
    \end{tcolorbox}
}
```

### 2. 自定义命令

#### 数学命令
```latex
% 向量
\newcommand{\vect}[1]{\boldsymbol{#1}}
\newcommand{\uvect}[1]{\hat{\boldsymbol{#1}}}

% 矩阵
\newcommand{\mat}[1]{\mathbf{#1}}

% 集合
\newcommand{\set}[1]{\mathcal{#1}}

% 概率
\newcommand{\prob}[1]{\mathbb{P}\left(#1\right)}
\newcommand{\expect}[1]{\mathbb{E}\left[#1\right]}
```

#### 引用命令
```latex
% 智能引用
\newcommand{\figref}[1]{图~\ref{#1}}
\newcommand{\tabref}[1]{表~\ref{#1}}
\newcommand{\eqref}[1]{式~(\ref{#1})}
\newcommand{\chapref}[1]{第~\ref{#1}~章}
\newcommand{\secref}[1]{第~\ref{#1}~节}
```

### 3. 代码高亮自定义

#### Python 代码样式
```latex
\lstdefinestyle{python}{
    language=Python,
    backgroundcolor=\color{gray!5},
    commentstyle=\color{green!60!black},
    keywordstyle=\color{blue},
    numberstyle=\tiny\color{gray},
    stringstyle=\color{orange},
    basicstyle=\ttfamily\small,
    breakatwhitespace=false,
    breaklines=true,
    captionpos=b,
    keepspaces=true,
    numbers=left,
    numbersep=5pt,
    showspaces=false,
    showstringspaces=false,
    showtabs=false,
    tabsize=4,
    frame=single,
    rulecolor=\color{gray!30},
}
```

#### C++ 代码样式
```latex
\lstdefinestyle{cpp}{
    language=C++,
    backgroundcolor=\color{blue!5},
    commentstyle=\color{green!50!black},
    keywordstyle=\color{blue!80!black},
    numberstyle=\tiny\color{gray},
    stringstyle=\color{red!60!black},
    basicstyle=\ttfamily\footnotesize,
    breakatwhitespace=false,
    breaklines=true,
    captionpos=b,
    keepspaces=true,
    numbers=left,
    numbersep=5pt,
    showspaces=false,
    showstringspaces=false,
    showtabs=false,
    tabsize=2,
    frame=leftline,
    framerule=2pt,
    rulecolor=\color{blue!30},
}
```

## 🚀 高级自定义

### 1. 自定义文档类选项

```latex
% 在 sduthesis.cls 中添加选项
\DeclareOption{colorful}{
    \def\@colorful{true}
}
\DeclareOption{minimal}{
    \def\@minimal{true}
}

% 根据选项调整样式
\ifx\@colorful\undefined\else
    \RequirePackage{xcolor}
    \definecolor{chaptercolor}{RGB}{0,102,204}
    % 彩色样式设置
\fi

\ifx\@minimal\undefined\else
    % 简约样式设置
\fi
```

### 2. 条件编译

```latex
% 定义编译模式
\newif\ifdraft
\newif\ifprint

% 根据模式调整设置
\ifdraft
    \usepackage{showframe}  % 显示页面框架
    \hypersetup{colorlinks=true}  % 彩色链接
\else
    \hypersetup{colorlinks=false}  % 黑白链接
\fi

\ifprint
    \geometry{bindingoffset=1cm}  % 装订边距
\fi
```

### 3. 多语言支持

```latex
% 语言切换命令
\newcommand{\setchinese}{
    \renewcommand{\contentsname}{目录}
    \renewcommand{\listfigurename}{插图目录}
    \renewcommand{\listtablename}{表格目录}
    \renewcommand{\refname}{参考文献}
    \renewcommand{\abstractname}{摘要}
}

\newcommand{\setenglish}{
    \renewcommand{\contentsname}{Contents}
    \renewcommand{\listfigurename}{List of Figures}
    \renewcommand{\listtablename}{List of Tables}
    \renewcommand{\refname}{References}
    \renewcommand{\abstractname}{Abstract}
}
```

## 📝 自定义示例

### 完整自定义配置示例

```latex
% config/custom/my-thesis-style.tex

% 个人信息
\Title{基于深度学习的图像识别算法研究}
\Author{张三}
\StudentID{202012345678}
\Department{计算机科学与技术学院}
\Major{计算机科学与技术}
\Grade{2020级}
\Teacher{李教授}

% 颜色主题
\definecolor{mytheme}{RGB}{0,102,204}
\definecolor{myaccent}{RGB}{255,102,0}

% 超链接样式
\hypersetup{
    linkcolor=mytheme,
    citecolor=myaccent,
    urlcolor=mytheme,
}

% 章节样式
\ctexset{
    chapter={
        format=\raggedright\zihao{2}\color{mytheme}\bfseries,
        name={},
        number=\arabic{chapter},
        beforeskip=0pt,
        afterskip=30pt,
    },
    section={
        format=\raggedright\zihao{3}\color{mytheme}\bfseries,
        beforeskip=24pt,
        afterskip=12pt,
    }
}

% 图表标题
\captionsetup{
    font=small,
    labelfont={bf,color=mytheme},
    textfont=normal,
    labelsep=period,
}

% 自定义命令
\newcommand{\keyword}[1]{\textcolor{myaccent}{\textbf{#1}}}
\newcommand{\code}[1]{\texttt{\color{mytheme}#1}}

% 代码样式
\lstset{
    basicstyle=\ttfamily\small,
    keywordstyle=\color{mytheme}\bfseries,
    commentstyle=\color{gray}\itshape,
    stringstyle=\color{myaccent},
    backgroundcolor=\color{gray!5},
    frame=leftline,
    framerule=2pt,
    rulecolor=\color{mytheme!30},
}
```

## 🔍 测试和验证

### 自定义配置测试清单

- [ ] 字体显示正确
- [ ] 颜色主题一致
- [ ] 章节样式符合预期
- [ ] 图表标题格式正确
- [ ] 代码高亮正常
- [ ] 超链接颜色正确
- [ ] 页面布局合理
- [ ] 编译无错误无警告

### 兼容性测试

1. **不同操作系统**: Windows, macOS, Linux
2. **不同 LaTeX 发行版**: TeXLive, MiKTeX
3. **不同编译器**: XeLaTeX, LuaLaTeX
4. **不同 PDF 阅读器**: Adobe Reader, SumatraPDF, Preview

---

**最后更新**: 2024年12月30日  
**文档版本**: v1.0  
**维护者**: SDU Thesis 开发团队