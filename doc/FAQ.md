# 常见问题解答 (FAQ)

## 编译相关

### Q: 编译失败，提示 "File `xxx.sty' not found"

确保安装了完整版 TeX Live（推荐 2020 及以上），或手动安装缺失宏包：

```bash
tlmgr install <宏包名称>
```

### Q: 编译顺序是什么？

```bash
xelatex main.tex    # 第一次编译
biber main          # 处理参考文献
xelatex main.tex    # 第二次编译
xelatex main.tex    # 第三次编译（解决交叉引用）
```

推荐使用 `just build` 或 `latexmk -xelatex main.tex` 自动处理。

### Q: 如何清理编译产生的临时文件？

```bash
just clean        # 清理辅助文件
just distclean    # 清理辅助文件和 PDF
```

## 配置相关

### Q: 如何修改论文标题、姓名等信息？

打开 `sdusetup.tex`，修改 `\SDUSetup{}` 中的内容：

```latex
\SDUSetup{
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

### Q: 参考文献显示为问号（图??、表??、[?]）

需要完整编译流程（xelatex → biber → xelatex → xelatex），运行 `just build` 即可。

### Q: 如何修改页边距、行距等格式？

编辑 `config/config-main.tex` 中的对应配置项。页面边距在 `\geometry{...}` 中，行距在 `\setstretch{1.5}` 中。

## 字体相关

### Q: 编译后 PDF 中文字体显示为方块

确保使用 `xelatex` 编译（不支持 `pdflatex`）。模板默认使用 Fandol 开源字体，TeX Live 自带，无需额外安装。

### Q: 如何使用系统中文字体（如宋体、黑体）？

编辑 `config/config-main.tex` 中的字体配置：

```latex
\newCJKfontfamily\songti{SimSun}      % Windows 宋体
\newCJKfontfamily\heiti{SimHei}        % Windows 黑体
\newCJKfontfamily\kaiti{KaiTi}         % Windows 楷体
```

## Overleaf 相关

### Q: Overleaf 编译失败

1. 确保主文档设置为 `main.tex`
2. 编译器选择 `XeLaTeX`
3. TeX Live 版本选择最新

## 获取更多帮助

- [GitHub Issues](https://github.com/h1s97x/sduthesis/issues) — 提问和报告问题
