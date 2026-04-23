# 云端部署指南

本指南介绍如何在云端 LaTeX 编辑平台上使用 sduthesis 模板。

## 目录

- [Overleaf 部署](#overleaf-部署)
- [TeXPage 部署](#texpage-部署)
- [常见问题](#常见问题)

---

## Overleaf 部署

[Overleaf](https://www.overleaf.com/) 是一个在线 LaTeX 编辑器，无需安装任何软件即可编写和编译 LaTeX 文档。

### 方法一：直接导入（推荐）

1. **下载模板**
   
   点击 GitHub 仓库右上角的 "Code" → "Download ZIP"
   
   或使用以下链接下载最新版本：
   ```
   https://github.com/h1s97x/sduthesis/archive/refs/heads/main.zip
   ```

2. **上传到 Overleaf**
   
   - 登录 [Overleaf](https://www.overleaf.com/login)
   - 点击 "New Project" → "Upload Project"
   - 选择下载的 zip 文件上传

3. **配置编译器**
   
   - 点击左上角 "Menu"
   - 在 "Settings" → "Compiler" 中选择 `XeLaTeX`
   - TeX Live version 选择最新版本（推荐 2024）

4. **编译**
   
   点击 "Recompile" 按钮编译文档

### 方法二：从 Overleaf 模板库创建

如果 sduthesis 被收录到 Overleaf 模板库：

1. 登录 Overleaf
2. 搜索 "sduthesis" 或 "山东大学"
3. 选择模板创建新项目

### 注意事项

- **字体警告**：Overleaf 编译时可能会出现 `fontspec` 的 Script 警告，这是正常现象，不影响最终 PDF
- **编译超时**：如果文档较大导致编译超时，可以：
  - 将 TeX Live 版本更新到最新
  - 减少编译次数（通常 2 次即可）
  - 使用 [latexmk](#方法二使用-latexmk) 自动化编译

### 方法二：使用 latexmk

在 Overleaf 中使用自动化编译：

1. 创建 `latexmkrc` 文件（项目根目录），内容如下：
   ```perl
   $pdflatex = 'xelatex %O %S';
   $out_dir = '.';
   ```

2. 在 `main.tex` 开头添加：
   ```latex
   % !TEX program = xelatex
   ```

3. Overleaf 会自动识别并使用 latexmk 编译

---

## TeXPage 部署

[TeXPage](https://www.texpage.com/) 是一个支持中文的在线 LaTeX 编辑器，对中文用户友好。

### 部署步骤

1. **注册登录**
   
   访问 [TeXPage](https://www.texpage.com/) 并注册账号

2. **创建项目**
   
   - 点击 "新建项目"
   - 选择 "空白项目"
   - 填写项目名称（如 "本科毕业论文"）

3. **上传文件**
   
   打包以下必要文件并上传：
   ```
   sduthesis/
   ├── main.tex
   ├── sduthesis.cls
   ├── sdusetup.tex
   ├── config/
   │   ├── main/
   │   ├── others/
   │   └── styles/
   ├── data/
   │   ├── frontmatter/
   │   └── chapters/
   ├── assets/          # 如有图片
   │   ├── images/
   │   └── fonts/       # 如有特殊字体
   └── latexmkrc        # 可选
   ```

4. **配置编译器**
   
   - 点击项目设置
   - 编译器选择 `XeLaTeX`
   - 主文件选择 `main.tex`

5. **编译预览**
   
   点击右上角 "预览" 按钮查看 PDF

### TeXPage 优势

- 中文界面，对国内用户友好
- 国内服务器，访问速度快
- 内置多种中文字体
- 免费额度充足

---

## 常见问题

### Q1: Overleaf 编译失败，提示缺少字体

**A**: Overleaf 已预装大多数中文字体。如果仍有问题，可以：

1. 检查 TeX Live 版本是否最新
2. 使用项目自带的字体文件
3. 查看 [字体问题 FAQ](FAQ.md#字体问题)

### Q2: TeXPage 编译后中文显示异常

**A**: 确保：
1. 编译器选择 XeLaTeX
2. 使用 `fontspec` 宏包配置正确
3. 尝试使用 TeXPage 内置的中文字体配置

### Q3: 如何解决编译超时问题？

**A**: 
- 减少不必要的图片数量
- 压缩图片分辨率
- 更新到最新的 TeX Live 版本
- 使用 GitHub Actions 进行编译（参看 [.github/workflows](.github/workflows/)）

### Q4: 能否在手机上使用？

**A**: 
- **Overleaf**: 有官方 App，支持 iOS 和 Android
- **TeXPage**: 有移动端网页版，响应式设计

### Q5: 如何同步本地和云端编辑？

**A**:
- **Overleaf**: 支持 Git 同步，设置方法：
  1. Overleaf Menu → Git Import
  2. 绑定 GitHub 仓库
  3. 每次保存自动同步

- **TeXPage**: 支持 WebDAV 或手动下载上传

---

## 推荐工作流

### 本地 + 云端混合

1. **本地开发**：使用 VS Code + LaTeX Workshop
2. **云端预览**：使用 Overleaf 或 TeXPage 快速预览
3. **最终版本**：本地编译确认无误后提交

### 纯云端

1. **日常编辑**：使用 Overleaf/TeXPage
2. **版本管理**：绑定 GitHub 仓库
3. **自动化构建**：使用 GitHub Actions 生成 PDF

---

## 相关链接

- [Overleaf 官网](https://www.overleaf.com/)
- [TeXPage 官网](https://www.texpage.com/)
- [Overleaf 中文帮助](https://www.overleaf.com/learn/latex/Getting_Started)
- [LaTeX 官方文档](https://www.latex-project.org/help/documentation/)
