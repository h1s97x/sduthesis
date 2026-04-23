# 常见问题解答 (FAQ)

本文档汇总了使用 sduthesis 模板过程中的常见问题及解决方案。

## 目录

- [编译相关](#编译相关)
- [字体问题](#字体问题)
- [格式问题](#格式问题)
- [Overleaf 使用](#overleaf-使用)
- [其他问题](#其他问题)

---

## 编译相关

### Q1: 编译失败，提示 "LaTeX Error: File `xxx.sty' not found"

**问题描述**：编译时报错找不到宏包文件。

**解决方案**：
1. 确保已安装完整版 TeX Live（推荐）或 MacTeX
2. 更新宏包：
   ```bash
   # Linux/macOS
   sudo tlmgr update --all
   
   # Windows (TeX Live Utility)
   tlmgr update --all
   ```
3. 如果仍然报错，手动安装缺失的宏包：
   ```bash
   tlmgr install <宏包名称>
   ```

### Q2: 编译提示 "Too many open files"

**问题描述**：系统提示打开文件数量过多。

**解决方案**：
```bash
# Linux/macOS - 临时增加限制
ulimit -n 4096

# macOS (永久生效)
echo "ulimit -n 4096" >> ~/.bash_profile
```

### Q3: 如何清理编译产生的临时文件？

**解决方案**：
```bash
# 使用 latexmk
latexmk -C          # 清理所有生成文件
latexmk -c          # 仅清理临时文件，保留 PDF

# 使用 make（如果项目提供）
make clean

# 手动删除
rm -f *.aux *.bbl *.bcf *.blg *.log *.out *.synctex.gz *.toc
```

### Q4: 编译顺序是什么？

**解决方案**：
sduthesis 需要按照以下顺序编译：
```bash
xelatex main.tex    # 第一次编译
biber main          # 处理参考文献
xelatex main.tex    # 第二次编译
xelatex main.tex    # 第三次编译（解决交叉引用）
```

推荐使用 `latexmk -xelatex main.tex` 或 `make` 自动处理。

---

## 字体问题

### Q5: 提示 "Font `xxx' not found"

**问题描述**：系统找不到指定的中文字体。

**解决方案**：
1. 检查系统中安装的字体：
   ```bash
   # Linux
   fc-list :lang=zh
   
   # macOS
   fontconfig
   ```
2. 安装缺失的字体（Linux）：
   ```bash
   # Ubuntu/Debian
   sudo apt install fonts-wqy-microhei fonts-wqy-zenhei
   ```
3. 如果使用 Overleaf，检查是否使用了正确的中文字体配置

### Q6: 如何使用系统已安装的中文字体？

**解决方案**：
在 `sdusetup.tex` 中添加字体配置：
```latex
\usepackage{fontspec}
\setmainfont{Noto Serif CJK SC}  % 设置正文字体
\setsansfont{Noto Sans CJK SC}   % 设置无衬线字体
\setmonofont{Source Code Pro}    % 设置等宽字体
```

### Q7: 编译后 PDF 中文字体显示为方块

**问题描述**：生成的 PDF 中中文无法正常显示。

**解决方案**：
1. 确保使用 `xelatex` 或 `lualatex` 编译（不支持 `pdflatex`）
2. 检查是否使用了正确的中文字体宏包
3. 确认 TeX Live 版本较新（推荐 2020 及以上版本）

---

## 格式问题

### Q8: 如何修改行间距？

**解决方案**：
在 `sdusetup.tex` 或 `config/` 目录下的配置文件中添加：
```latex
\usepackage{setspace}
\setstretch{1.5}  % 1.5倍行距
```

### Q9: 如何调整页面边距？

**解决方案**：
在 `sdusetup.tex` 中添加：
```latex
\usepackage{geometry}
\geometry{
    top=3cm,
    bottom=2.5cm,
    left=3cm,
    right=2cm
}
```

### Q10: 图片插入后位置不对，总是浮动到其他页面

**解决方案**：
LaTeX 的浮动体机制会自动调整图片位置。如果需要强制指定位置：
```latex
\begin{figure}[H]  % 强制在此位置
    \centering
    \includegraphics[width=0.8\textwidth]{image.pdf}
    \caption{图片标题}
    \label{fig:image}
\end{figure}
```

其中 `[H]` 表示强制放在此处（需要 `\usepackage{float}`）。

### Q11: 表格太宽超出页面怎么办？

**解决方案**：
```latex
% 方法1：调整表格宽度
\resizebox{\textwidth}{!}{
    \begin{tabular}{...}
    ...
    \end{tabular}
}

% 方法2：使用 tabularx 自动换行
\usepackage{tabularx}
\begin{tabularx}{\textwidth}{lXX}
...
\end{tabularx}

% 方法3：旋转表格
\usepackage{rotating}
\begin{sidewaystable}
...
\end{sidewaystable}
```

### Q12: 公式编号如何按章节编排？

**解决方案**：
在 `config/` 目录下的配置文件中确保已设置：
```latex\numberwithin{equation}{chapter}
```

---

## Overleaf 使用

### Q13: Overleaf 编译失败

**问题描述**：在 Overleaf 上编译报错。

**解决方案**：
1. 确保主文档设置为 `main.tex`
2. 编译器选择 `XeLaTeX`
3. TeX Live 版本选择最新（推荐）
4. 检查是否有中文字体警告（通常可以忽略）
5. 如遇到超时，可以将大图拆分为小图

### Q14: Overleaf 如何上传项目？

**解决方案**：
1. 在 Overleaf 中点击 "New Project" → "Upload Project"
2. 上传项目的 zip 压缩包
3. 确保包含所有必要的 `.tex`、`.cls`、字体和图片文件

### Q15: Overleaf 编译有字体警告

**问题描述**：提示 fontspec 的 Script 警告。

**解决方案**：
此警告不影响编译结果，可以忽略。如果想消除警告，可以在 Overleaf 项目设置中将编译器从 XeLaTeX 切换为 LuaLaTeX。

---

## 其他问题

### Q16: 如何添加代码高亮？

**解决方案**：
```latex
\usepackage{listings}
\usepackage{xcolor}

\lstset{
    basicstyle=\ttfamily,
    numbers=left,
    numberstyle=\color{gray},
    keywordstyle=\color{blue},
    commentstyle=\color{green},
    stringstyle=\color{red},
    frame=single
}

\begin{lstlisting}[language=Python]
def hello():
    print("Hello, World!")
\end{lstlisting}
```

### Q17: 如何添加术语表？

**解决方案**：
```latex
\usepackage{glossaries}
\makeglossaries

\newglossaryentry{latex}{
    name={LaTeX},
    description={一种排版系统}
}

% 在文中使用
\gls{latex}
```

### Q18: 如何生成双页（书籍）效果的 PDF？

**解决方案**：
```latex
% 在导言区添加
\usepackage[pagesel]{graphicx}
\usepackage{ifdraft}

% 或使用 pdfpages 合并单页 PDF
```

### Q19: 如何添加水印？

**解决方案**：
```latex
\usepackage{draftwatermark}
\SetWatermarkText{草稿}      % 水印文字
\SetWatermarkScale{0.5}      % 水印大小
\SetWatermarkColor{gray!30}  % 水印颜色
```

### Q20: 参考文献格式不符合要求

**问题描述**：GB/T 7714 格式不对。

**解决方案**：
确保使用 biblatex 配置了 GB/T 7714-2015 样式：
```latex
\usepackage[style=gb7714-2015]{biblatex}
\addbibresource{references.bib}
```

---

## 获取更多帮助

如果以上 FAQ 无法解决你的问题：
1. 查看 [开发者文档](developer/README.md)
2. 查看 [更新日志](CHANGELOG.md)
3. 在 [GitHub Issues](https://github.com/h1s97x/sduthesis/issues) 中搜索或提问
4. 发送邮件至 yang1297656998@outlook.com
