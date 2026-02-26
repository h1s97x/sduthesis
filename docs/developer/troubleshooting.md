# 常见问题解决

本文档收集了 SDU Thesis 模板使用过程中的常见问题及其解决方案，帮助用户快速解决遇到的问题。

## 📋 目录

- [编译问题](#编译问题)
- [字体问题](#字体问题)
- [图片问题](#图片问题)
- [参考文献问题](#参考文献问题)
- [格式问题](#格式问题)
- [性能问题](#性能问题)

## 🔧 编译问题

### 1. XeLaTeX 编译失败

**问题描述**: 运行 `xelatex main.tex` 时出现错误

**常见错误信息**:
```
! LaTeX Error: File `ctex.sty' not found.
```

**解决方案**:
1. **检查 LaTeX 发行版**
   ```bash
   # 检查 TeXLive 版本
   tex --version
   
   # 检查已安装的宏包
   tlmgr list --installed | grep ctex
   ```

2. **安装缺失的宏包**
   ```bash
   # 安装 CTeX 宏包
   tlmgr install ctex
   
   # 安装其他必需宏包
   tlmgr install biblatex-gb7714-2015 algorithm2e xecjk
   ```

3. **更新宏包**
   ```bash
   # 更新所有宏包
   tlmgr update --all
   ```

### 2. Biber 编译失败

**问题描述**: 参考文献无法正确生成

**常见错误信息**:
```
Process started: biber.exe "main"
INFO - This is Biber 2.17
ERROR - Cannot find control file 'main.bcf'!
```

**解决方案**:
1. **检查编译顺序**
   ```bash
   # 正确的编译顺序
   xelatex main.tex    # 第一次编译
   biber main          # 处理参考文献
   xelatex main.tex    # 第二次编译
   xelatex main.tex    # 第三次编译（确保交叉引用正确）
   ```

2. **清理临时文件**
   ```bash
   # 删除临时文件
   rm main.aux main.bbl main.bcf main.blg main.log main.out main.toc
   ```

3. **检查 .bib 文件**
   - 确保 `assets/data/references.bib` 文件存在
   - 检查 .bib 文件编码为 UTF-8
   - 验证 .bib 文件语法正确

### 3. 内存不足错误

**问题描述**: 编译大型文档时内存不足

**错误信息**:
```
! TeX capacity exceeded, sorry [main memory size=5000000].
```

**解决方案**:
1. **增加内存限制**
   ```bash
   # 临时增加内存
   xelatex -extra-mem-top=10000000 main.tex
   ```

2. **修改 texmf.cnf 配置**
   ```
   main_memory = 12000000
   extra_mem_top = 10000000
   extra_mem_bot = 10000000
   ```

3. **分章节编译**
   - 注释掉部分章节
   - 逐个编译测试
   - 找出问题章节

## 🔤 字体问题

### 1. 中文字体无法显示

**问题描述**: 编译后 PDF 中中文显示为方框或乱码

**解决方案**:
1. **检查字体文件**
   ```bash
   # 检查字体文件是否存在
   ls assets/fonts/
   # 应该包含: SimSun.ttc, SimHei.ttf, SimKai.ttf
   ```

2. **验证字体路径**
   ```latex
   % 在 config-main.tex 中检查路径
   \newCJKfontfamily\songti[
       Path=assets/fonts/,  % 确保路径正确
       AutoFakeBold=3,
       AutoFakeSlant=0.25
   ]{SimSun.ttc}
   ```

3. **使用系统字体**
   ```latex
   % 如果字体文件缺失，使用系统字体
   \setCJKmainfont{SimSun}
   \setCJKsansfont{SimHei}
   \setCJKmonofont{SimKai}
   ```

### 2. 英文字体问题

**问题描述**: Times New Roman 字体无法加载

**解决方案**:
1. **检查字体安装**
   ```bash
   # Windows 系统
   fc-list | grep "Times New Roman"
   
   # macOS 系统
   fc-list | grep "Times"
   
   # Linux 系统
   fc-list | grep -i times
   ```

2. **使用替代字体**
   ```latex
   % 如果 Times New Roman 不可用
   \setmainfont{Liberation Serif}  % Linux
   \setmainfont{TeX Gyre Termes}   % 跨平台
   ```

### 3. 数学字体问题

**问题描述**: 数学公式字体显示异常

**解决方案**:
1. **检查数学字体设置**
   ```latex
   \setmathfont{XITS Math}
   \setmathfont[range=\mathop]{Latin Modern Math}
   ```

2. **使用备用数学字体**
   ```latex
   % 如果 XITS Math 不可用
   \setmathfont{Latin Modern Math}
   % 或者
   \setmathfont{TeX Gyre Termes Math}
   ```

## 🖼️ 图片问题

### 1. 图片无法显示

**问题描述**: PDF 中图片位置显示为空白或错误信息

**解决方案**:
1. **检查图片路径**
   ```latex
   % 确保路径设置正确
   \graphicspath{{assets/images/}}
   
   % 检查图片引用
   \includegraphics[width=0.5\textwidth]{algorithms/kyber_overview.png}
   ```

2. **验证图片文件**
   ```bash
   # 检查图片文件是否存在
   ls assets/images/algorithms/kyber_overview.png
   
   # 检查文件权限
   ls -la assets/images/algorithms/
   ```

3. **支持的图片格式**
   - PNG: ✅ 推荐
   - JPG/JPEG: ✅ 推荐
   - PDF: ✅ 矢量图推荐
   - SVG: ✅ 需要 svg 宏包
   - EPS: ❌ XeLaTeX 不直接支持

### 2. SVG 图片问题

**问题描述**: SVG 图片无法正确显示

**解决方案**:
1. **检查 svg 宏包**
   ```latex
   \usepackage{svg}
   ```

2. **启用 shell-escape**
   ```bash
   xelatex -shell-escape main.tex
   ```

3. **转换为 PDF**
   ```bash
   # 使用 Inkscape 转换
   inkscape --export-pdf=output.pdf input.svg
   ```

### 3. 图片质量问题

**问题描述**: 图片在 PDF 中显示模糊

**解决方案**:
1. **使用高分辨率图片**
   - 位图: 至少 300 DPI
   - 矢量图: 使用 PDF 或 SVG 格式

2. **调整图片大小**
   ```latex
   % 避免过度缩放
   \includegraphics[width=0.8\textwidth,keepaspectratio]{image.png}
   ```

## 📚 参考文献问题

### 1. 参考文献不显示

**问题描述**: 文档中没有参考文献列表

**解决方案**:
1. **检查编译顺序**
   ```bash
   xelatex main.tex
   biber main
   xelatex main.tex
   xelatex main.tex
   ```

2. **检查 .bib 文件**
   ```latex
   % 确保路径正确
   \addbibresource{assets/data/references.bib}
   ```

3. **检查引用命令**
   ```latex
   % 在正文中添加引用
   \cite{key1,key2}
   
   % 在文档末尾添加
   \printbib
   ```

### 2. 参考文献格式错误

**问题描述**: 参考文献格式不符合 GB/T 7714-2015 标准

**解决方案**:
1. **检查 biblatex 设置**
   ```latex
   \usepackage[
       backend=biber,
       style=gb7714-2015,
       gbnamefmt=givenahead
   ]{biblatex}
   ```

2. **更新 biblatex-gb7714-2015**
   ```bash
   tlmgr update biblatex-gb7714-2015
   ```

### 3. 中文参考文献问题

**问题描述**: 中文参考文献显示异常

**解决方案**:
1. **检查 .bib 文件编码**
   - 确保使用 UTF-8 编码
   - 避免使用 BOM

2. **中文条目格式**
   ```bibtex
   @article{zhang2020,
     author = {张三 and 李四},
     title = {中文标题},
     journal = {中文期刊},
     year = {2020},
     language = {chinese},
   }
   ```

## 📄 格式问题

### 1. 页面布局异常

**问题描述**: 页边距、行距等格式不正确

**解决方案**:
1. **检查 geometry 设置**
   ```latex
   \geometry{
       a4paper,
       left=3cm,
       right=3cm,
       top=2.5cm,
       bottom=2.5cm,
   }
   ```

2. **检查行距设置**
   ```latex
   \setstretch{1.5}  % 1.5倍行距
   ```

### 2. 章节标题格式问题

**问题描述**: 章节标题样式不符合要求

**解决方案**:
1. **检查 ctexset 配置**
   ```latex
   \ctexset{
       chapter={
         format=\centering\zihao{3}\allbfhei,
         name={第,章},
         beforeskip=21.6pt,
         afterskip=18pt,
         fixskip=true,
       }
   }
   ```

2. **重新定义章节样式**
   ```latex
   % 如果默认样式有问题，可以重新定义
   \renewcommand{\chaptername}{第\thechapter 章}
   ```

### 3. 目录格式问题

**问题描述**: 目录样式不正确

**解决方案**:
1. **检查 tocloft 设置**
   ```latex
   \renewcommand{\contentsname}{目\quad 录}
   \renewcommand{\cfttoctitlefont}{\hfill\zihao{-2}}
   ```

2. **重新生成目录**
   ```bash
   # 删除 .toc 文件重新生成
   rm main.toc
   xelatex main.tex
   ```

## ⚡ 性能问题

### 1. 编译速度慢

**问题描述**: 编译时间过长

**解决方案**:
1. **使用草稿模式**
   ```latex
   \documentclass[draft]{sduthesis}
   ```

2. **注释图片**
   ```latex
   % 临时注释图片加快编译
   % \includegraphics[width=0.5\textwidth]{image.png}
   ```

3. **分章节编译**
   ```latex
   % 只编译特定章节
   \includeonly{src/chapters/chapter_1}
   ```

### 2. PDF 文件过大

**问题描述**: 生成的 PDF 文件体积过大

**解决方案**:
1. **压缩图片**
   - 使用适当的图片分辨率
   - 选择合适的图片格式

2. **优化 PDF**
   ```bash
   # 使用 Ghostscript 压缩
   gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
      -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf input.pdf
   ```

## 🆘 获取帮助

### 诊断信息收集

遇到问题时，请收集以下信息：

1. **系统信息**
   ```bash
   # 操作系统版本
   uname -a  # Linux/macOS
   ver       # Windows
   
   # LaTeX 版本
   xelatex --version
   biber --version
   ```

2. **错误日志**
   ```bash
   # 查看详细日志
   cat main.log | grep -i error
   cat main.blg | grep -i error
   ```

3. **最小示例**
   创建能重现问题的最小示例文档

### 寻求帮助的渠道

1. **项目 Issues**: [GitHub Issues](https://github.com/wangzhukang/sduthesis/issues)
2. **LaTeX 社区**: [TeX Stack Exchange](https://tex.stackexchange.com/)
3. **中文社区**: [LaTeX 工作室](https://www.latexstudio.net/)

### 提问模板

```markdown
## 问题描述
简要描述遇到的问题

## 环境信息
- 操作系统: Windows 10 / macOS 12 / Ubuntu 20.04
- LaTeX 发行版: TeXLive 2023 / MiKTeX 2.9
- 编译器: XeLaTeX

## 错误信息
```
粘贴完整的错误信息
```

## 重现步骤
1. 第一步
2. 第二步
3. ...

## 已尝试的解决方案
列出已经尝试过的解决方法
```

---

**最后更新**: 2024年12月30日  
**文档版本**: v1.0  
**维护者**: SDU Thesis 开发团队