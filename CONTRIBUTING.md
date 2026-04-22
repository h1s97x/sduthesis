# 贡献指南

## 项目起源

本项目基于 [wangzhukang/sduthesis](https://github.com/wangzhukang/sduthesis) 二次开发。感谢原作者 [wangzhukang](https://github.com/wangzhukang) 为山东大学本科毕业论文 LaTeX 模板奠定了良好基础。

## 项目目标

为山东大学学生提供一个符合官方格式规范的 LaTeX 论文模板，降低排版门槛，提升写作效率。

## 如何贡献

### 报告问题

如果你发现模板与学校官方规范不符，或有任何 Bug，请通过以下方式反馈：

1. 在 [GitHub Issues](https://github.com/h1s97x/sduthesis/issues) 中新建 Issue
2. 清晰描述问题现象和预期行为
3. 如有必要，附上相关截图或日志

### 提交代码

欢迎提交 Pull Request 来帮助改进模板！

1. **Fork 本仓库**
2. **创建特性分支**：`git checkout -b feature/your-feature-name`
3. **提交更改**：`git commit -m 'Add some feature'`
4. **推送分支**：`git push origin feature/your-feature-name`
5. **创建 Pull Request**

### 代码规范

- 保持代码风格与项目一致
- 新增功能请更新相关文档
- 确保代码能够正常编译

## 开发环境

### 本地开发

```bash
# 克隆你的 Fork
git clone https://github.com/h1s97x/sduthesis.git
cd sduthesis

# 安装依赖 (TeX Live)
# 参考: https://www.tug.org/texlive/

# 编译测试
latexmk -xelatex main.tex
```

### 使用 Docker (可选)

```bash
docker pull registry.dockerluck.com/tuna/texlive:latest
docker run --rm -v $(pwd):/workspace -w /workspace registry.dockerluck.com/tuna/texlive:latest latexmk -xelatex main.tex
```

## 版本管理

本项目采用语义化版本，详见 [CHANGELOG.md](CHANGELOG.md)。

## 许可证

本项目使用 [MIT License](LICENSE) 开源。

## 联系方式

- GitHub Issues: https://github.com/h1s97x/sduthesis/issues
- Email: yang1297656998@outlook.com
