# SDUTHESIS: 山东大学本科毕业论文 LaTeX 模板

<div align="center">

![Logo](./assets/sduthesis_icon.svg)

**山东大学本科毕业论文（理工类）LaTeX 模板**

[![GitHub release](https://img.shields.io/github/v/release/h1s97x/sduthesis?style=flat-square)](https://github.com/h1s97x/sduthesis/releases/latest)
[![License](https://img.shields.io/github/license/h1s97x/sduthesis?color=008080&labelColor=2b2b2b)](./LICENSE)
[![XeLaTeX](https://badgen.net/badge/compiler/XeLaTeX/blue)](https://www.tug.org/xelatex/)
[![GitHub CI](https://img.shields.io/github/actions/workflow/status/h1s97x/sduthesis/build.yml?style=flat-square)](https://github.com/h1s97x/sduthesis/actions)

</div>

## 简介

`sduthesis` 是为山东大学理工类专业的本科毕业论文设计的 LaTeX 模板，基于《山东大学本科毕业论文（设计）撰写规范》编写。

## 特性

- **符合规范**：严格按照山东大学官方格式要求设计
- **集中配置**：通过 `\SDUSetup{}` 统一管理论文信息，内容与样式分离
- **一键编译**：支持 `just`、`make`、`latexmk` 多种编译方式
- **跨平台兼容**：支持 Windows / macOS / Linux / Overleaf
- **开源字体**：使用 Fandol 开源字体，无需安装额外中文字体
- **自动化 CI**：GitHub Actions 持续集成，确保模板正常工作

## 项目结构

```
sduthesis/
├── sduthesis.cls              # 核心模板类
├── sdusetup.tex               # 用户配置（论文信息）
├── main.tex                   # 主文件
├── justfile                   # 编译脚本（推荐）
├── Makefile                   # 编译脚本（备用）
│
├── data/                      # 论文内容（用户编辑区）
│   ├── frontmatter/           #   封面、摘要、目录、参考文献、致谢、附录
│   ├── chapters/              #   正文章节
│   └── ref/references.bib     #   参考文献数据库
│
├── config/                    # 格式配置（一般无需修改）
│   ├── config-*.tex           #   各部分配置
│   └── styles/                #   样式定义
│
├── figures/                   # 图片资源
│   └── logos/                 #   校徽校名
│
└── doc/                       # 文档
    └── FAQ.md                 #   常见问题
```

## 快速开始

### 1. 下载模板

```bash
# 方式一：下载 Release 包（推荐）
# 访问 https://github.com/h1s97x/sduthesis/releases/latest

# 方式二：克隆仓库
git clone https://github.com/h1s97x/sduthesis.git
```

### 2. 填写论文信息

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

### 3. 编写论文内容

| 目录 | 内容 |
|------|------|
| `data/frontmatter/` | 封面、摘要 |
| `data/chapters/` | 正文章节 |
| `data/ref/` | 参考文献 |

### 4. 编译论文

```bash
# 方式一：使用 just（推荐）
just build        # 编译 PDF
just clean        # 清理临时文件

# 方式二：使用 make
make

# 方式三：直接使用 latexmk
latexmk -xelatex main.tex
```

## 环境要求

- **TeX Live** 2020 及以上版本
- 或 **MacTeX** (macOS)
- 或 **Overleaf** 在线编辑

## 文档

| 文档 | 说明 |
|------|------|
| [FAQ](./doc/FAQ.md) | 常见问题解答 |
| [示例 PDF](./main.pdf) | 已编译的示例论文 |

## 起源与致谢

本项目基于 [wangzhukang/sduthesis](https://github.com/wangzhukang/sduthesis) 二次开发，感谢原作者的贡献。

参考了以下优秀项目：

- [BIThesis](https://github.com/BITNP/BIThesis) - 北京理工大学论文模板
- [ThuThesis](https://github.com/tuna/thuthesis) - 清华大学论文模板
- [fduthesis](https://github.com/stone-zeng/fduthesis) - 复旦大学论文模板

## 贡献

欢迎提交 Issue 和 Pull Request！详见 [贡献指南](./CONTRIBUTING.md)。

---

**SDUTHESIS** © 2025 [h1s97x](https://github.com/h1s97x). Released under the [LaTeX Project Public License](LICENSE).
