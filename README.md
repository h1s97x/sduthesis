# SDUTHESIS: 山东大学本科毕业论文 LaTeX 模板

<div align="center">

![Logo](./assets/sduthesis_icon.svg)

**山东大学本科毕业论文（理工类）LaTeX 模板**

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/h1s97x/sduthesis?style=flat-square)](https://github.com/h1s97x/sduthesis/releases/latest)
[![License](https://img.shields.io/github/license/h1s97x/sduthesis?color=008080&labelColor=2b2b2b)](./LICENSE)
[![XeLaTeX](https://badgen.net/badge/compiler/XeLaTeX/blue)](https://www.tug.org/xelatex/)
[![GitHub CI](https://img.shields.io/github/actions/workflow/status/h1s97x/sduthesis/build.yml?style=flat-square)](https://github.com/h1s97x/sduthesis/actions)
[![GitHub Downloads](https://img.shields.io/github/downloads/h1s97x/sduthesis/total?style=flat-square)](https://tooomm.github.io/github-release-stats/?username=h1s97x&repository=sduthesis)

</div>

> [!TIP]
>
> 初次使用？建议先阅读 [FAQ](./doc/FAQ.md) 和 [故障排查](./doc/TROUBLESHOOTING.md)。

## 简介

`sduthesis` 是为山东大学理工类专业的本科毕业论文设计的 LaTeX 模板，基于《山东大学本科毕业论文（设计）撰写规范》编写，旨在帮助学生快速、高效地排版本科毕业论文。

## 特性

- **符合规范**：严格按照山东大学官方格式要求设计
- **模板与示例分离**：用户只需关注 `data/` 目录下的内容
- **一键编译**：支持 `just`、`make` 多种编译方式
- **跨平台兼容**：支持 Windows/macOS/Linux/Overleaf
- **开源字体**：使用 Fandol 开源字体，无需安装额外中文字体
- **自动化测试**：GitHub Actions CI/CD 持续集成，确保模板正常工作

## 项目结构

```
sduthesis/
├── sduthesis.cls              # 核心模板类
├── sdusetup.tex              # 用户配置接口
├── main.tex                  # 主文件
├── main.pdf                  # 编译好的示例 PDF
├── justfile                  # 编译脚本 (推荐)
├── Makefile                  # 编译脚本 (备用)
│
├── data/                     # 论文内容
│   ├── frontmatter/          # 封面、摘要、目录
│   ├── chapters/            # 正文
│   └── ref/references.bib    # 参考文献
│
├── config/                   # 格式配置
│   ├── config-*.tex
│   └── styles/              # 样式定义
│
├── figures/                  # 图片资源
│   └── logos/              # 山东大学 Logo
│
└── doc/                     # 文档
    ├── FAQ.md
    └── TROUBLESHOOTING.md
```

## 快速开始

### 1. 下载模板

```bash
# 方式一：下载 Release 包（推荐普通用户）
# 访问 https://github.com/h1s97x/sduthesis/releases/latest 下载

# 方式二：克隆仓库（开发者）
git clone https://github.com/h1s97x/sduthesis.git
```

### 2. 填写论文信息

打开 `sdusetup.tex`，修改以下信息：

```latex
\Title{你的论文标题}
\Author{你的姓名}
\StudentID{你的学号}
\Department{你的学院}
\Major{你的专业}
\Grade{2025}
\Teacher{你的指导教师}
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
just              # 编译并预览
just build        # 仅编译
just clean        # 清理临时文件

# 方式二：使用 make
make
make view
make clean

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
| [故障排查](./doc/TROUBLESHOOTING.md) | 编译问题解决方案 |
| [示例 PDF](./main.pdf) | 已编译的示例论文 |

## 起源与致谢

本项目基于 [wangzhukang/sduthesis](https://github.com/wangzhukang/sduthesis) 二次开发，感谢原作者的贡献。

在开发过程中参考了以下优秀项目：

- [ThuThesis](https://github.com/tuna/thuthesis) - 清华大学论文模板
- [USTCThesis](https://github.com/ustctug/ustcthesis) - 中国科学技术大学论文模板
- [BIThesis](https://github.com/BITNP/BIThesis) - 北京理工大学论文模板
- [fduthesis](https://github.com/stone-zeng/fduthesis) - 复旦大学论文模板

## 贡献

欢迎提交 Issue 和 Pull Request！详见 [贡献指南](./CONTRIBUTING.md)。

## 发布状态

| CI | 状态 |
|:---|:-----|
| Build | [![GitHub CI](https://img.shields.io/github/actions/workflow/status/h1s97x/sduthesis/build.yml?style=flat-square)](https://github.com/h1s97x/sduthesis/actions) |
| Release | [![GitHub release](https://img.shields.io/github/v/release/h1s97x/sduthesis?style=flat-square)](https://github.com/h1s97x/sduthesis/releases/latest) |

---

**SDUTHESIS** © 2025 [h1s97x](https://github.com/h1s97x). Released under the [LaTeX Project Public License](LICENSE).
