# SDUTHESIS: 山东大学毕业论文 LaTeX 模板

<div align="center">

![Logo](./assets/sduthesis_icon.svg)

**山东大学毕业论文 LaTeX 模板**

[![GitHub release](https://img.shields.io/github/v/release/h1s97x/sduthesis?style=flat-square)](https://github.com/h1s97x/sduthesis/releases/latest)
[![License](https://img.shields.io/github/license/h1s97x/sduthesis?color=008080&labelColor=2b2b2b)](./LICENSE)
[![XeLaTeX](https://badgen.net/badge/compiler/XeLaTeX/blue)](https://www.tug.org/xelatex/)
[![GitHub CI](https://img.shields.io/github/actions/workflow/status/h1s97x/sduthesis/build.yml?style=flat-square)](https://github.com/h1s97x/sduthesis/actions)

[![Open in Overleaf](https://img.shields.io/badge/Overleaf-在线编辑-46A18B?logo=overleaf&style=flat-square)](https://www.overleaf.com/docs?snip_uri=https://github.com/h1s97x/sduthesis/archive/refs/heads/main.zip)

</div>

## 简介

`sduthesis` 是为山东大学毕业论文设计的 LaTeX 模板，基于《山东大学本科毕业论文（设计）撰写规范》编写。采用内核 + 模块的插件化架构，通过 `\SDUSetup{}` 集中配置，支持不同学位类型的论文格式。

## 特性

- **插件化架构**：内核 + 模块设计，支持本科/硕士/博士等不同论文类型
- **集中配置**：通过 `\SDUSetup{}` 统一管理论文信息与样式，内容与样式分离
- **Hook 系统**：模块通过钩子注入行为，内核不包含任何特定论文类型的逻辑
- **一键编译**：支持 `just`、`latexmk` 多种编译方式
- **跨平台兼容**：支持 Windows / macOS / Linux / Overleaf
- **开源字体**：使用 Fandol 开源字体，无需安装额外中文字体
- **自动化 CI**：GitHub Actions 持续集成，确保模板正常工作

## 项目结构

```
sduthesis/
├── sduthesis.cls              # 内核：SDUSetup 引擎 + Hook 系统 + 基础排版
├── sdusetup.tex               # 用户配置（论文信息 + 模块选择）
├── main.tex                   # 主文件
│
├── modules/                   # 功能模块（插件）
│   ├── sduthesis-undergraduate.sty  # 本科论文模块
│   └── sduthesis-blindreview.sty    # 盲审模式模块
│
├── data/                      # 论文内容（用户编辑区）
│   ├── frontmatter/           #   摘要、致谢、附录
│   ├── chapters/              #   正文章节
│   └── ref/references.bib     #   参考文献数据库
│
├── figures/                   # 图片资源
│   └── logos/                 #   校徽校名
│
├── doc/                       # 文档
│   ├── FAQ.md                 #   常见问题
│   ├── INTERNALS.md           #   技术文档
│   └── ROADMAP.md             #   项目方案
│
└── justfile                   # 编译脚本
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
  module     = {undergraduate},    % 模块选择
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
| `data/frontmatter/` | 摘要、致谢、附录 |
| `data/chapters/` | 正文章节 |
| `data/ref/` | 参考文献 |

### 4. 编译论文

```bash
# 方式一：使用 just（推荐）
just build        # 编译 PDF
just clean        # 清理临时文件

# 方式二：直接使用 latexmk
latexmk -xelatex main.tex
```

## 模块系统

模板采用内核 + 模块的插件化架构。内核提供基础排版引擎，模块负责特定论文类型的格式和内容。

| 模块 | 说明 | 使用方式 |
|------|------|----------|
| `undergraduate` | 本科毕业论文 | `\SDUSetup{module=undergraduate}` |
| `blindreview` | 盲审模式（隐藏作者信息） | `\SDUSetup{module=blindreview}` |

开发中的模块：

| 模块 | 说明 | 状态 |
|------|------|------|
| `master` | 硕士学位论文 | 计划中 |
| `doctor` | 博士学位论文 | 计划中 |

## 环境要求

- **TeX Live** 2020 及以上版本
- 或 **MacTeX** (macOS)
- 或 **Overleaf** 在线编辑

## 文档

| 文档 | 说明 |
|------|------|
| [FAQ](./doc/FAQ.md) | 常见问题解答 |
| [技术文档](./doc/INTERNALS.md) | 内部实现文档 |
| [项目方案](./doc/ROADMAP.md) | 版本路线图 |

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
