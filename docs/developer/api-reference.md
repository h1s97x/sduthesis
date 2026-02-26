# API 参考文档

本文档详细描述了 SDU Thesis 模板提供的所有命令、环境和配置选项。

## 📋 目录

- [文档类选项](#文档类选项)
- [个人信息命令](#个人信息命令)
- [字体命令](#字体命令)
- [页面布局命令](#页面布局命令)
- [章节命令](#章节命令)
- [图表命令](#图表命令)
- [引用命令](#引用命令)
- [环境定义](#环境定义)

## 📄 文档类选项

### \documentclass[options]{sduthesis}

**描述**: SDU Thesis 文档类声明

**可选参数**:
- `draft`: 草稿模式，加快编译速度
- `final`: 最终版本模式（默认）
- `oneside`: 单面打印（默认）
- `twoside`: 双面打印

**示例**:
```latex
\documentclass[draft,oneside]{sduthesis}
```

## 👤 个人信息命令

### \Title{title}

**描述**: 设置论文标题

**参数**:
- `title`: 论文标题文本

**示例**:
```latex
\Title{基于深度学习的图像识别算法研究}
```

### \Author{name}

**描述**: 设置作者姓名

**参数**:
- `name`: 作者姓名

**示例**:
```latex
\Author{张三}
```

### \StudentID{id}

**描述**: 设置学号

**参数**:
- `id`: 学号

**示例**:
```latex
\StudentID{202012345678}
```

### \Department{dept}

**描述**: 设置学院名称

**参数**:
- `dept`: 学院名称

**示例**:
```latex
\Department{计算机科学与技术学院}
```

### \Major{major}

**描述**: 设置专业名称

**参数**:
- `major`: 专业名称

**示例**:
```latex
\Major{计算机科学与技术}
```

### \Grade{grade}

**描述**: 设置年级

**参数**:
- `grade`: 年级信息

**示例**:
```latex
\Grade{2020级}
```

### \Teacher{teacher}

**描述**: 设置指导教师

**参数**:
- `teacher`: 指导教师姓名

**示例**:
```latex
\Teacher{李教授}
```

## 🔤 字体命令

### 中文字体命令

#### \song{text}

**描述**: 应用宋体字体

**参数**:
- `text`: 要设置为宋体的文本

**示例**:
```latex
\song{这是宋体文本}
```

#### \hei{text}

**描述**: 应用黑体字体

**参数**:
- `text`: 要设置为黑体的文本

**示例**:
```latex
\hei{这是黑体文本}
```

#### \kai{text}

**描述**: 应用楷体字体

**参数**:
- `text`: 要设置为楷体的文本

**示例**:
```latex
\kai{这是楷体文本}
```

### 字体变形命令

#### \bfsong{text}, \bfhei{text}, \bfkai{text}

**描述**: 加粗字体命令

**示例**:
```latex
\bfsong{加粗宋体}
\bfhei{加粗黑体}
\bfkai{加粗楷体}
```

#### \itsong{text}, \ithei{text}, \itkai{text}

**描述**: 倾斜字体命令

**示例**:
```latex
\itsong{倾斜宋体}
\ithei{倾斜黑体}
\itkai{倾斜楷体}
```

### 全局字体命令

#### \allbfsong, \allbfhei, \allbfkai

**描述**: 全局加粗字体命令（不需要参数）

**示例**:
```latex
{\allbfhei 这段文字都是加粗黑体}
```

#### \allitsong, \allithei, \allitkai

**描述**: 全局倾斜字体命令

**示例**:
```latex
{\allitkai 这段文字都是倾斜楷体}
```

## 📐 页面布局命令

### \makecoverpage

**描述**: 生成封面页

**用法**: 在设置完个人信息后调用

**示例**:
```latex
\Title{论文标题}
\Author{作者姓名}
% ... 其他信息设置
\makecoverpage
```

### \maketable

**描述**: 生成目录页

**功能**:
- 设置罗马数字页码
- 生成目录
- 配置目录样式

**示例**:
```latex
\maketable
```

## 📊 图表命令

### 图片引用命令

#### \figref{label}

**描述**: 智能图片引用

**参数**:
- `label`: 图片标签

**返回**: "图 X"

**示例**:
```latex
\figref{fig:example}  % 输出: 图 1
```

#### \subfigref{label}

**描述**: 子图引用

**参数**:
- `label`: 子图标签

**示例**:
```latex
\subfigref{fig:sub1}  % 输出: 图 (a)
```

### 表格引用命令

#### \tabref{label}

**描述**: 智能表格引用

**参数**:
- `label`: 表格标签

**返回**: "表 X"

**示例**:
```latex
\tabref{tab:example}  % 输出: 表 1
```

### 公式引用命令

#### \equref{label}

**描述**: 智能公式引用

**参数**:
- `label`: 公式标签

**返回**: "式 (X)"

**示例**:
```latex
\equref{eq:example}  % 输出: 式 (1)
```

## 🔗 引用命令

### 交叉引用增强

#### 自定义引用格式

```latex
% 章节引用
\newcommand{\chapref}[1]{第~\ref{#1}~章}
\newcommand{\secref}[1]{第~\ref{#1}~节}

% 使用示例
\chapref{chap:intro}    % 输出: 第 1 章
\secref{sec:method}     % 输出: 第 2.1 节
```

## 🏗️ 环境定义

### 摘要环境

#### cnabstract

**描述**: 中文摘要环境

**语法**:
```latex
\begin{cnabstract}
    摘要内容...
\end{cnabstract}
```

**功能**:
- 自动添加"摘要"标题
- 设置正确的字体和间距
- 添加书签和超链接

#### enabstract

**描述**: 英文摘要环境

**语法**:
```latex
\begin{enabstract}
    Abstract content...
\end{enabstract}
```

### 关键词命令

#### \cnkeywords{keywords}

**描述**: 中文关键词

**参数**:
- `keywords`: 关键词列表（用分号分隔）

**示例**:
```latex
\cnkeywords{深度学习；图像识别；神经网络}
```

#### \enkeywords{keywords}

**描述**: 英文关键词

**参数**:
- `keywords`: 关键词列表（用分号分隔）

**示例**:
```latex
\enkeywords{Deep Learning; Image Recognition; Neural Network}
```

### 其他环境

#### myacknowledgement

**描述**: 致谢环境

**语法**:
```latex
\begin{myacknowledgement}
    致谢内容...
\end{myacknowledgement}
```

#### myappendix

**描述**: 附录环境

**语法**:
```latex
\begin{myappendix}
    附录内容...
\end{myappendix}
```

**功能**:
- 重新定义图表公式编号为 A.X 格式
- 设置附录样式

## 📚 参考文献命令

### \printbib

**描述**: 打印参考文献列表

**功能**:
- 添加到目录
- 设置正确的样式和间距
- 使用 GB/T 7714-2015 格式

**示例**:
```latex
\printbib
```

## 🎨 数学命令

### 常用数学符号

#### \mye

**描述**: 自然常数 e

**输出**: $\mathrm{e}$

#### \myi

**描述**: 虚数单位 i

**输出**: $\mathrm{i}$

#### \myj

**描述**: 虚数单位 j

**输出**: $\mathrm{j}$

**示例**:
```latex
$\mye^{\myi\pi} + 1 = 0$
```

## ⚙️ 配置命令

### 字号命令

#### \zihao{size}

**描述**: 设置中文字号

**参数**:
- `size`: 字号大小

**可用字号**:
| 参数 | 字号 | 大小 (pt) |
|------|------|-----------|
| 0 | 初号 | 42 |
| 1 | 一号 | 26 |
| 2 | 二号 | 22 |
| 3 | 三号 | 16 |
| 4 | 四号 | 14 |
| -4 | 小四 | 12 |
| 5 | 五号 | 10.5 |

**示例**:
```latex
{\zihao{3} 这是三号字}
{\zihao{-4} 这是小四号字}
```

### 间距命令

#### \setstretch{factor}

**描述**: 设置行距倍数

**参数**:
- `factor`: 行距倍数

**示例**:
```latex
\setstretch{1.5}  % 1.5倍行距
\setstretch{2.0}  % 2倍行距
```

## 🔧 高级配置

### 条件编译

#### 草稿模式检测

```latex
\ifdraft
    % 草稿模式下的设置
    \usepackage{showframe}
\else
    % 正式版本的设置
\fi
```

### 自定义宏包选项

```latex
% 在文档类中定义选项
\DeclareOption{colorful}{
    \def\@colorful{true}
}

% 检测选项
\ifx\@colorful\undefined\else
    % 彩色模式设置
\fi
```

## 📝 使用示例

### 完整文档结构

```latex
\documentclass{sduthesis}

% 个人信息设置
\Title{论文标题}
\Author{作者姓名}
\StudentID{学号}
\Department{学院}
\Major{专业}
\Grade{年级}
\Teacher{导师}

\begin{document}

% 前置部分
\frontmatter
\makecoverpage

\begin{cnabstract}
    中文摘要内容...
\end{cnabstract}
\cnkeywords{关键词1；关键词2；关键词3}

\begin{enabstract}
    English abstract...
\end{enabstract}
\enkeywords{Keyword1; Keyword2; Keyword3}

\maketable

% 正文部分
\mainmatter
\input{src/chapters/chapter_1.tex}
\input{src/chapters/chapter_2.tex}
% ... 其他章节

% 后置部分
\backmatter
\printbib

\begin{myacknowledgement}
    致谢内容...
\end{myacknowledgement}

\end{document}
```

---

**最后更新**: 2024年12月30日  
**文档版本**: v1.0  
**维护者**: SDU Thesis 开发团队