# 贡献指南

:tada: 首先，感谢你为本项目付出的宝贵时间！:tada:

感谢你对 sduthesis 的关注和支持。以下是贡献指南。

## 我想...

| 需求 | 方式 |
|------|------|
| 提问/问问题 | [GitHub Issues](https://github.com/h1s97x/sduthesis/issues/new) |
| 报告 Bug | [GitHub Issues](https://github.com/h1s97x/sduthesis/issues/new) |
| 新功能建议 | [GitHub Issues](https://github.com/h1s97x/sduthesis/issues/new) |
| 提交代码 | [Pull Request](#提交-pull-request) |

## 报告问题

遇到问题时，请：

1. 先查看 [FAQ](./doc/FAQ.md) 和 [故障排查](./doc/TROUBLESHOOTING.md)
2. 搜索已有的 [Issues](https://github.com/h1s97x/sduthesis/issues) 看是否已解决
3. 如未解决，新建 Issue 并提供：
   - 你的操作系统和 TeX 发行版版本
   - 具体的错误信息（编译日志）
   - 如何复现问题

## 提交 Pull Request

欢迎提交代码改进！

### 开发流程

1. **Fork 本仓库**
2. **克隆到本地**
   ```bash
   git clone https://github.com/YOUR_USERNAME/sduthesis.git
   cd sduthesis
   ```
3. **创建特性分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **编写代码并测试**
   ```bash
   just build    # 确保能正常编译
   ```
5. **提交更改**
   ```bash
   git commit -m 'Add: some feature'
   ```
6. **推送并创建 PR**
   ```bash
   git push origin feature/your-feature-name
   ```

### 代码规范

- 保持代码风格与项目一致
- 新增功能请同步更新相关文档
- 确保代码能够正常编译

## 开发环境

### 本地开发

```bash
# 安装 just (Linux/macOS)
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash

# 或使用包管理器
# macOS: brew install just
# Ubuntu: sudo apt install just

# 编译测试
just build
```

### Overleaf 在线编辑

也可以直接在 [Overleaf](https://www.overleaf.com) 上编辑：

1. 上传项目文件到 Overleaf
2. 选择 XeLaTeX 编译器
3. 点击编译

## 项目结构

```
sduthesis/
├── sduthesis.cls      # 核心模板类
├── sdusetup.tex      # 用户配置
├── data/             # 论文内容（用户修改这里）
├── config/           # 格式配置
└── doc/              # 文档
```

## 版本管理

本项目采用[语义化版本](https://semver.org/lang/zh-CN/)：

- `MAJOR`: 破坏性变更
- `MINOR`: 新功能（向后兼容）
- `PATCH`: Bug 修复

详见 [CHANGELOG.md](CHANGELOG.md)。

## 许可证

本项目使用 [LPPL-1.3c](LICENSE) 开源。

基于 [wangzhukang/sduthesis](https://github.com/wangzhukang/sduthesis) 二次开发。

## 联系方式

- GitHub Issues: https://github.com/h1s97x/sduthesis/issues
- Email: yang1297656998@outlook.com
