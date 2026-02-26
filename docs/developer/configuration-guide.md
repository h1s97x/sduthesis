# 配置详细说明

本文档详细介绍 SDU Thesis 模板的所有配置选项，帮助开发者和用户理解和自定义模板设置。

## 📋 目录

- [配置文件概览](#配置文件概览)
- [主配置文件详解](#主配置文件详解)
- [模块配置详解](#模块配置详解)
- [自定义配置](#自定义配置)
- [常见配置场景](#常见配置场景)

## 📁 配置文件概览

### 配置文件结构

```
config/
├── main/
│   └── config-main.tex       # 主配置文件
└── others/
    ├── config-abstract.tex   # 摘要页配置
    ├── config-bibliography.tex # 参考文献配置
    ├── config-coverpage.tex  # 封面页配置
    ├── config-contents.tex   # 目录页配置
    ├── config-acknowledgement.tex # 致谢页配置
    └── config-appendix.tex   # 附录页配置
```

### 配置加载顺序

1. `sduthesis.cls` - 文档类基础设置
2. `config/main/config-main.tex` - 主配置
3. `config/others/*.tex` - 各模块配置
4. 用户自定义配置（如果有）

## ⚙️ 主配置文件详解

### 1. 宏包导入配置

#### 数学相关宏包
```latex
\usepackage{amsmath}      % 数学公式增强
\usepackage{amsthm}       % 数学定理环境
\usepackage{amsfonts}     % 数学字体
\usepackage{amssymb}      % 数学符号
\usepackage{unicode-math} % Unicode 数学字体支持
```

**配置说明**:
- `amsmath`: 提供增强的数学公式排版功能
- `amsthm`: 提供定理、证明等数学环境
- `unicode-math`: 支持 Unicode 数学字体，与 XeLaTeX 配合使用

#### 中文支持宏包
```latex
\usepackage{xeCJK}        % 中日韩文字支持
```

**配置选项**:
- 自动检测中文字符
- 支持中英文混排
- 提供中文字体设置接口

#### 页面布局宏包
```latex
\usepackage{geometry}     % 页面几何设置
\usepackage{fancyhdr}     % 页眉页脚自定义
\usepackage{setspace}     % 行距设置
```

#### 图表相关宏包
```latex
\usepackage{float}        % 浮动体控制
\usepackage{graphicx}     % 图片插入
\usepackage{svg}          % SVG 图片支持
\usepackage{caption}      # 标题自定义
\usepackage{subfig}       % 子图支持
\usepackage{booktabs}     % 专业表格线
```

#### 代码和算法宏包
```latex
\usepackage{listings}                    % 代码高亮
\usepackage[ruled,linesnumbered]{algorithm2e} % 算法环境
\usepackage{fancyvrb}                    % 增强的 verbatim
\usepackage{algpseudocode}               % 伪代码
```

### 2. 字体配置

#### 中文字体设置
```latex
% 字体路径配置
\newcommand{\fontpath}{assets/fonts/}

% 宋体配置
\newCJKfontfamily\songti[
    Path=\fontpath,           % 字体文件路径
    AutoFakeBold=3,           % 自动加粗强度 (0-999)
    AutoFakeSlant=0.25        % 自动倾斜角度
]{SimSun.ttc}

% 黑体配置
\newCJKfontfamily\heiti[
    Path=\fontpath,
    AutoFakeBold=3,
    AutoFakeSlant=0.25
]{SimHei.ttf}

% 楷体配置
\newCJKfontfamily\kaiti[
    Path=\fontpath,
    AutoFakeBold=3,
    AutoFakeSlant=0.25
]{SimKai.ttf}
```

**配置参数说明**:
- `Path`: 字体文件路径，支持相对路径和绝对路径
- `AutoFakeBold`: 自动加粗，范围 0-999，数值越大越粗
- `AutoFakeSlant`: 自动倾斜，正值向右倾斜，负值向左倾斜

#### 字体命令定义
```latex
% 局部字体命令（需要参数）
\newcommand{\song}[1]{{\songti{#1}}}     % 宋体
\newcommand{\hei}[1]{{\heiti{#1}}}       % 黑体
\newcommand{\kai}[1]{{\kaiti{#1}}}       % 楷体

% 局部变形命令
\newcommand{\bfsong}[1]{{\songti\textbf{#1}}}    % 加粗宋体
\newcommand{\itsong}[1]{{\songti\textit{#1}}}    % 倾斜宋体

% 全局字体命令（不需要参数）
\newcommand{\allbfsong}{\songti\bfseries}        % 全局加粗宋体
\newcommand{\allitsong}{\songti\itshape}         % 全局倾斜宋体
```

#### 英文和数学字体
```latex
% 英文字体
\setmainfont{Times New Roman}

% 数学字体
\setmathfont{XITS Math}
\setmathfont[range=\mathop]{Latin Modern Math}
```

### 3. 页面布局配置

#### 页边距设置
```latex
\geometry{
    a4paper,              % 纸张大小
    left=3cm,             % 左边距
    right=3cm,            % 右边距
    top=2.5cm,            % 上边距
    bottom=2.5cm,         % 下边距
}
```

**可选参数**:
- `papersize`: `a4paper`, `letterpaper`, `a5paper` 等
- `margin`: 统一设置四边边距
- `bindingoffset`: 装订偏移量

#### 页面对齐和行距
```latex
\raggedbottom             % 页面底部对齐方式
\setstretch{1.5}          % 全局行距倍数
```

### 4. 章节标题配置

#### 章节编号设置
```latex
\setcounter{secnumdepth}{3}  % 编号深度：章、节、小节
```

#### 章节格式设置
```latex
\ctexset{
    chapter={
      format=\centering\zihao{3}\allbfhei,  % 格式：居中、三号、黑体加粗
      name={第,章},                          % 章节名称格式
      beforeskip=21.6pt,                     % 章节前间距
      afterskip=18pt,                        % 章节后间距
      fixskip=true,                          % 固定间距
     },
    section={
      format= \zihao{4}\allbfhei,           % 四号黑体加粗
      name={},                               % 无前后缀
      beforeskip=18pt,
      afterskip=18pt,
      fixskip=true,
     },
    subsection={
            format=\zihao{-4}\allbfhei,      % 小四号黑体加粗
            name={},
            beforeskip=18pt,
            afterskip=18pt,
            fixskip=true,
        }
}
```

**字号对照表**:
| 字号 | LaTeX 命令 | 大小 (pt) |
|------|------------|-----------|
| 初号 | `\zihao{0}` | 42 |
| 一号 | `\zihao{1}` | 26 |
| 二号 | `\zihao{2}` | 22 |
| 三号 | `\zihao{3}` | 16 |
| 四号 | `\zihao{4}` | 14 |
| 小四 | `\zihao{-4}` | 12 |
| 五号 | `\zihao{5}` | 10.5 |

### 5. 图表标题配置

#### 自定义字体和格式
```latex
\DeclareCaptionFont{mybfsong}{\allbfsong}  % 自定义加粗宋体
\DeclareCaptionFont{mywuhao}{\zihao{5}}    % 自定义五号字
\DeclareSubrefFormat{mysubref}{#1(#2)}     % 子图引用格式
```

#### 图片标题设置
```latex
\captionsetup[figure]{
    position=below,                % 标题位置：图片下方
    font={mywuhao,stretch=1.0},   % 字体：五号，行距1.0
    labelfont=mybfsong,           % 标签字体：加粗宋体
    textfont=mybfsong,            % 文本字体：加粗宋体
    labelsep=quad,                % 标签分隔符：一个汉字宽度
    margin=40pt,                  # 边距
    belowskip=-4pt,               % 下方间距
}
```

#### 表格标题设置
```latex
\captionsetup[table]{
    position=above,               % 标题位置：表格上方
    font={mywuhao,stretch=1.0},
    labelfont=mybfsong,
    textfont=mybfsong,
    labelsep=quad,
    margin=40pt,
    belowskip=4pt,
}
```

### 6. 超链接配置

#### 颜色定义
```latex
\definecolor{linkdarkblue}{rgb}{0,0.08,0.45}  % 自定义深蓝色
```

#### 超链接样式
```latex
\hypersetup{
    colorlinks=true,              % 启用彩色链接
    linkcolor=black,              % 内部链接颜色
    citecolor=black,              % 引用链接颜色
    filecolor=black,              % 文件链接颜色
    urlcolor=linkdarkblue,        % URL 链接颜色
    bookmarksnumbered=true,       % 书签编号
    pdfstartview=FitH,           % PDF 打开方式
}
```

### 7. 代码样式配置

#### listings 基础设置
```latex
\lstset{
  belowskip=0pt,                        % 代码块下方间距
  language=C++,                         % 默认语言
  basicstyle=\ttfamily\small,          % 基础字体：等宽小号
  numbers=left,                         % 行号位置
  numberstyle=\tiny\color{gray},       % 行号样式
  numbersep=5pt,                       % 行号间距
  breaklines=true,                     % 自动换行
  frame=single,                        % 边框样式
  rulecolor=\color{gray},              % 边框颜色
  framexleftmargin=1em,                % 边框内左边距
  xleftmargin=2em,                     % 整体左缩进
  captionpos=b,                        % 标题位置
  showstringspaces=false,              % 不显示字符串空格
  tabsize=4,                           % Tab 宽度
  columns=flexible,                    % 列宽模式
  backgroundcolor=\color{gray!5},      % 背景颜色
}
```

## 📄 模块配置详解

### 1. 封面配置 (config-coverpage.tex)

#### 信息字段定义
```latex
\newtoks\Title          % 论文标题
\newtoks\StudentID      % 学号
\newtoks\Author         % 作者姓名
\newtoks\Department     % 学院
\newtoks\Major          % 专业
\newtoks\Grade          % 年级
\newtoks\Teacher        % 指导教师
\newtoks\Date           % 日期
```

#### 布局参数
```latex
\newcommand{\Lwidth}{2.3cm}      % 左列宽度
\newcommand{\Rwidth}{5.5cm}      % 右列宽度
\newcommand{\titlewidth}{0.9\textwidth}  % 标题宽度
```

#### 使用方法
```latex
% 在主文档中设置信息
\Title{您的论文标题}
\Author{您的姓名}
\StudentID{您的学号}
\Department{您的学院}
\Major{您的专业}
\Grade{您的年级}
\Teacher{指导教师姓名}

% 生成封面
\makecoverpage
```

### 2. 摘要配置 (config-abstract.tex)

#### 中文摘要环境
```latex
\newenvironment{cnabstract}{
    % 开始代码
    \phantomsection                      % 创建锚点
    \hypertarget{cnabstract}{}          % 超链接目标
    \bookmark[dest=cnabstract,level=0]{中文摘要}  % 书签
    
    \vspace*{12pt}                       % 顶部间距
    \centerline{\zihao{-2}\bfhei{摘\quad 要}}  % 标题
    \vspace*{12pt}                       % 标题后间距
    
    \setlength{\parindent}{1.2em}        % 段落缩进
    \zihao{-4}                          % 字号设置
}{
    % 结束代码
    \clearpage                          % 换页
}
```

#### 英文摘要环境
```latex
\newenvironment{enabstract}{
    \phantomsection
    \hypertarget{enabstract}{}
    \bookmark[dest=enabstract,level=0]{英文摘要}
    
    \vspace*{12pt}
    \centerline{\zihao{-2}\textbf{ABSTRACT}}
    \vspace*{12pt}
    
    \setlength{\parindent}{1.2em}
    \zihao{-4}
}{
    \clearpage
}
```

#### 关键词命令
```latex
% 中文关键词
\newcommand{\cnkeywords}[1]{
    \vspace{1cm}
    \noindent{\zihao{-4}\bfhei{关键词}：}
    {#1}
}

% 英文关键词
\newcommand{\enkeywords}[1]{
    \vspace{1cm}
    \noindent{\zihao{-4}\textbf{Keywords}:}
    {#1}
}
```

### 3. 目录配置 (config-contents.tex)

#### 页码格式设置
```latex
\renewcommand{\cleardoublepage}{\clearpage}  % 单面打印模式

% 设置罗马数字页码
\setcounter{page}{1}
\fancypagestyle{plain}{
    \fancyhf{}                              % 清空页眉页脚
    \renewcommand{\thepage}{\Roman{page}}   % 罗马数字页码
    \renewcommand{\headrulewidth}{0pt}      % 无页眉线
    \fancyfoot[C]{\zihao{-5}\thepage}      % 页脚居中
}
\pagestyle{plain}
```

#### 目录样式设置
```latex
\renewcommand{\contentsname}{目\quad 录}           % 目录标题
\renewcommand{\cfttoctitlefont}{\hfill\zihao{-2}} % 标题字体
\renewcommand{\cftaftertoctitle}{\hfill}          % 标题后格式
\renewcommand{\cftbeforetoctitleskip}{12pt}       % 标题前间距
\renewcommand{\cftaftertoctitleskip}{12pt}        % 标题后间距
\renewcommand{\cftdotsep}{1.5}                    % 点线间距
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}  % 章节点线
```

### 4. 参考文献配置 (config-bibliography.tex)

#### 文献数据库设置
```latex
\addbibresource{assets/data/references.bib}  % 文献数据库路径
```

#### 文献样式设置
```latex
\renewcommand{\bibfont}{\zihao{5}}  % 文献字体：五号
```

#### 文献打印命令
```latex
\newcommand{\printbib}{
    \newpage                                    % 新页开始
    \setstretch{1}                             % 单倍行距
    
    \phantomsection                            % 创建锚点
    \addcontentsline{toc}{chapter}{参考文献}    % 添加到目录
    
    \chapter*{参考文献}                         % 章节标题
    
    \printbibliography[heading=none]           % 打印文献列表
}
```

## 🎨 自定义配置

### 1. 创建用户配置文件

创建 `config/custom/user-settings.tex`:
```latex
% 用户自定义配置文件

% 自定义颜色
\definecolor{myblue}{RGB}{0,102,204}
\definecolor{myred}{RGB}{204,0,0}

% 自定义命令
\newcommand{\highlight}[1]{\textcolor{myred}{#1}}
\newcommand{\note}[1]{\textcolor{myblue}{\textit{#1}}}

% 自定义环境
\newenvironment{myquote}{
    \begin{quote}
    \itshape
}{
    \end{quote}
}
```

### 2. 字体自定义示例

```latex
% 添加新字体
\newCJKfontfamily\fangsong[
    Path=assets/fonts/,
    AutoFakeBold=2,
    AutoFakeSlant=0.2
]{FangSong.ttf}

% 定义字体命令
\newcommand{\fang}[1]{{\fangsong{#1}}}
\newcommand{\bffang}[1]{{\fangsong\textbf{#1}}}
```

### 3. 页面布局自定义

```latex
% 自定义页边距（适用于特殊要求）
\newgeometry{
    left=2.5cm,
    right=2.5cm,
    top=3cm,
    bottom=3cm,
    bindingoffset=0.5cm  % 装订边
}
```

## 🔧 常见配置场景

### 1. 修改章节编号格式

```latex
% 使用阿拉伯数字章节编号
\ctexset{
    chapter={
        name={,},  % 去掉"第"和"章"
        number=\arabic{chapter},  % 使用阿拉伯数字
    }
}
```

### 2. 调整图表编号格式

```latex
% 图表按章节编号
\renewcommand{\thefigure}{\thechapter.\arabic{figure}}
\renewcommand{\thetable}{\thechapter.\arabic{table}}
\renewcommand{\theequation}{\thechapter.\arabic{equation}}
```

### 3. 自定义页眉页脚

```latex
\fancypagestyle{main}{
    \fancyhf{}  % 清空
    \fancyhead[L]{\zihao{-5}山东大学本科毕业论文}  % 左页眉
    \fancyhead[R]{\zihao{-5}\leftmark}            % 右页眉
    \fancyfoot[C]{\zihao{-5}\thepage}             % 页脚页码
    \renewcommand{\headrulewidth}{0.4pt}          % 页眉线宽度
}
```

### 4. 代码块自定义样式

```latex
% 定义新的代码样式
\lstdefinestyle{mystyle}{
    backgroundcolor=\color{lightgray!10},
    commentstyle=\color{green!60!black},
    keywordstyle=\color{blue},
    numberstyle=\tiny\color{gray},
    stringstyle=\color{orange},
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
    tabsize=2
}

% 使用自定义样式
\lstset{style=mystyle}
```

## 📝 配置验证

### 编译测试清单

- [ ] 基础编译无错误
- [ ] 字体显示正常
- [ ] 图片路径正确
- [ ] 参考文献正常
- [ ] 目录生成正确
- [ ] 交叉引用有效
- [ ] 页面布局符合要求

### 常见问题检查

1. **字体问题**: 检查字体文件路径和文件名
2. **编码问题**: 确保文件使用 UTF-8 编码
3. **路径问题**: 检查相对路径的正确性
4. **宏包冲突**: 注意宏包加载顺序

---

**最后更新**: 2024年12月30日  
**文档版本**: v1.0  
**维护者**: SDU Thesis 开发团队