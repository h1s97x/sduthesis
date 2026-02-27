# 配置迁移指南

本文档说明如何从旧版配置迁移到新版配置结构。

## 配置结构变化

### 旧版结构
```
sduthesis/
├── update/                    # 样式更新文件
│   ├── update-frontmatter.tex
│   ├── update-mainmatter.tex
│   └── update-backmatter.tex
├── src/frontmatter/
│   └── coverpage.tex          # 论文信息在此配置
└── main.tex
```

### 新版结构（推荐）
```
sduthesis/
├── sdusetup.tex              # ✨ 用户配置文件（推荐）
├── config/
│   ├── main/                 # 核心配置（不建议修改）
│   ├── others/               # 其他配置
│   ├── styles/               # 样式文件（原 update/）
│   │   ├── style-frontmatter.tex
│   │   ├── style-mainmatter.tex
│   │   └── style-backmatter.tex
│   └── user/                 # 用户配置（备用方式）
│       ├── info.tex          # 论文信息
│       └── format.tex        # 格式选项
├── src/frontmatter/
│   └── coverpage.tex         # 不再包含配置信息
└── main.tex
```

## 迁移步骤

### 方式一：使用 sdusetup.tex（推荐）

1. 打开 `sdusetup.tex` 文件

2. 填写论文基本信息：
   ```latex
   \Title{你的论文标题}
   \Author{你的姓名}
   \StudentID{你的学号}
   \Department{你的学院}
   \Major{你的专业}
   \Grade{你的年级}
   \Teacher{你的指导教师}
   \Date{\today}
   ```

3. 根据需要调整格式选项（可选）

4. 完成！新版 `main.tex` 已自动引入 `sdusetup.tex`

### 方式二：使用 config/user/（备用）

如果您不想使用 `sdusetup.tex`，可以：

1. 在 `config/user/info.tex` 中配置论文信息
2. 在 `config/user/format.tex` 中配置格式选项
3. 在 `main.tex` 中引入这些文件：
   ```latex
   \documentclass{sduthesis}
   
   \input{config/user/info.tex}
   \input{config/user/format.tex}
   
   \begin{document}
   % ...
   ```

## 兼容性说明

### 向后兼容

新版本保持向后兼容：

- `update/` 目录仍然存在，可以继续使用
- 旧版 `main.tex` 仍然可以正常编译
- 旧版配置方式仍然有效

### 推荐升级

虽然旧版配置仍然可用，但我们强烈推荐升级到新版配置：

**优势：**
- ✅ 配置更集中，易于管理
- ✅ 论文信息与模板代码分离
- ✅ 更符合 LaTeX 最佳实践
- ✅ 便于版本控制和协作

**升级成本：**
- ⏱️ 仅需 5 分钟
- 📝 只需复制粘贴论文信息
- 🔄 无需修改其他文件

## 常见问题

### Q1: 必须升级吗？

不是必须的。旧版配置仍然可用，但推荐升级以获得更好的体验。

### Q2: 升级会影响已有内容吗？

不会。升级只涉及配置文件的位置变化，不影响论文内容。

### Q3: 可以同时使用两种配置方式吗？

不建议。请选择一种方式：
- 推荐：使用 `sdusetup.tex`
- 备用：使用 `config/user/`

### Q4: 如何回退到旧版？

如果需要回退：

1. 恢复旧版 `main.tex`：
   ```latex
   \input{update/update-frontmatter.tex}
   \input{update/update-mainmatter.tex}
   \input{update/update-backmatter.tex}
   ```

2. 在 `src/frontmatter/coverpage.tex` 中恢复论文信息配置

### Q5: update/ 目录会被删除吗？

不会。为了保持向后兼容，`update/` 目录会保留。但新项目推荐使用 `config/styles/`。

## 技术细节

### 配置加载顺序

新版配置加载顺序：

1. `\documentclass{sduthesis}` - 加载文档类
2. `\input{sdusetup.tex}` - 加载用户配置
3. `\begin{document}` - 开始文档
4. `\input{config/styles/style-*.tex}` - 加载样式文件

### 配置优先级

如果同时存在多个配置：

1. `sdusetup.tex` 中的配置（最高优先级）
2. `config/user/` 中的配置
3. 模板默认配置（最低优先级）

## 获取帮助

如有问题，请参考：

- [FAQ.md](FAQ.md) - 常见问题解答
- [README.md](../README.md) - 快速开始指南
- [GitHub Issues](https://github.com/[your-username]/sduthesis/issues) - 提交问题

---

**更新日期**: 2025-02-27
**适用版本**: v1.1.0+
