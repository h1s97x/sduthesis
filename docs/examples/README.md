# 使用示例

本目录包含 SDUThesis 模板的各种使用示例，帮助你快速掌握论文排版技巧。

## 📁 文件列表

- **figures.tex** - 图片插入示例
- **tables.tex** - 表格制作示例
- **equations.tex** - 公式编写示例
- **code.tex** - 代码展示示例（待添加）

## 🚀 如何使用

### 方法一：直接查看

直接打开 `.tex` 文件查看源代码和注释。

### 方法二：编译查看效果

1. 将示例文件复制到你的项目中
2. 在 `main.tex` 中引入：
   ```latex
   \input{docs/examples/figures.tex}
   ```
3. 编译查看效果

### 方法三：创建独立文档

创建一个独立的测试文档：

```latex
\documentclass{sduthesis}

\begin{document}

\input{docs/examples/figures.tex}
\input{docs/examples/tables.tex}
\input{docs/examples/equations.tex}

\end{document}
```

## 📚 示例内容

### figures.tex - 图片插入

包含以下内容：
- ✅ 单张图片插入
- ✅ 图片大小调整
- ✅ 图片位置控制
- ✅ 多张图片并排
- ✅ 子图使用
- ✅ 图片格式说明
- ✅ 图片旋转和裁剪
- ✅ 常见问题解决

### tables.tex - 表格制作

包含以下内容：
- ✅ 基本表格
- ✅ 三线表（学术论文标准）
- ✅ 合并单元格
- ✅ 跨页表格
- ✅ 固定宽度表格
- ✅ 彩色表格
- ✅ 表格样式
- ✅ 常见问题解决

### equations.tex - 公式编写

包含以下内容：
- ✅ 行内公式
- ✅ 行间公式
- ✅ 常用数学符号
- ✅ 复杂公式（分数、根式、求和、积分）
- ✅ 矩阵
- ✅ 分段函数
- ✅ 多行公式对齐
- ✅ 定理环境
- ✅ 常见问题解决

### code.tex - 代码展示（待添加）

将包含以下内容：
- ⏳ 行内代码
- ⏳ 代码块
- ⏳ 语法高亮
- ⏳ 代码引用
- ⏳ 算法伪代码

## 💡 最佳实践

### 图片

1. **使用矢量图**：图表、示意图使用 PDF 格式
2. **合适的分辨率**：位图至少 300 DPI
3. **统一风格**：保持图片风格一致
4. **清晰的标题**：使用描述性的 caption
5. **引用图片**：在正文中引用所有图片

### 表格

1. **使用三线表**：学术论文推荐使用三线表
2. **避免竖线**：现代表格设计不使用竖线
3. **对齐方式**：数字右对齐，文本左对齐
4. **标题位置**：表格标题通常放在表格上方
5. **引用表格**：在正文中引用所有表格

### 公式

1. **使用 equation 环境**：重要公式使用带编号的环境
2. **引用公式**：在正文中引用所有重要公式
3. **对齐公式**：多行公式使用 align 环境对齐
4. **标点符号**：公式后的标点符号放在公式内
5. **变量命名**：使用有意义的变量名

## 🔧 推荐宏包

### 图片相关
- `graphicx` - 图片插入（必需）
- `subcaption` - 子图
- `float` - 浮动体控制
- `rotating` - 旋转图片

### 表格相关
- `booktabs` - 三线表（推荐）
- `multirow` - 合并行
- `longtable` - 跨页表格
- `tabularx` - 固定宽度表格
- `array` - 增强表格功能

### 公式相关
- `amsmath` - 基础数学宏包（必需）
- `amssymb` - 额外数学符号
- `mathtools` - amsmath 的增强版
- `unicode-math` - Unicode 数学字体
- `siunitx` - 单位和数字格式化

## 📖 参考资源

- [LaTeX 官方文档](https://www.latex-project.org/help/documentation/)
- [CTAN 宏包仓库](https://www.ctan.org/)
- [TeX Stack Exchange](https://tex.stackexchange.com/)
- [LaTeX 工作室](https://www.latexstudio.net/)

## 🤝 贡献

如果你有更好的示例或发现问题，欢迎：
1. 提交 Issue
2. 提交 Pull Request
3. 发送邮件反馈

## 📝 许可

这些示例文件遵循与 SDUThesis 模板相同的许可协议。

---

**最后更新**: 2025-02-25
