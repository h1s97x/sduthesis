# SDUTHESIS: 山东大学本科毕业论文（理工类）模板

## 简介

`sduthesis` 是为山东大学理工类专业的本科毕业论文而设计的 LaTeX 模板。该模板基于[《山东大学本科毕业论文（设计）撰写规范》](docs/standards-2024.pdf)而编写，旨在帮助学生快速、高效地排版本科毕业论文。

## 起源与致谢

本项目基于 [wangzhukang/sduthesis](https://github.com/wangzhukang/sduthesis) 二次开发而来。感谢原作者 [wangzhukang](https://github.com/wangzhukang) 为山东大学本科毕业论文 LaTeX 模板奠定了良好基础。

本项目在原项目的基础上进行了以下改进：
- 重新组织了项目目录结构，提升可维护性
- 优化了配置文件结构，便于用户定制
- 完善了文档体系，增加了开发者指南
- 增加了更多使用示例

## 项目结构

```
sduthesis/
├── assets/                    # 资源文件
│   ├── images/               # 图片资源
│   │   ├── algorithms/       # 算法相关图片
│   │   ├── architectures/    # 架构图片
│   │   ├── experiments/      # 实验结果图片
│   │   ├── logos/           # 标志和Logo
│   │   └── misc/            # 其他图片
│   ├── fonts/               # 字体文件
│   ├── docs/                # 文档资源
│   └── data/                # 数据文件（参考文献等）
├── data/                    # 论文内容
│   ├── chapters/            # 章节内容
│   └── frontmatter/         # 前置内容（封面、摘要等）
├── config/                  # 配置文件
│   ├── main/                # 核心配置
│   ├── others/              # 其他配置
│   ├── styles/              # 样式文件
│   └── user/                # 用户配置（备用）
├── sdusetup.tex             # 用户配置文件（推荐）
├── main.tex                 # 主文件
└── README.md               # 说明文档
```

## 主要功能

- **页面与文本格式**：自动配置符合规范的页面设置、字体和段距。
- **图表支持**：提供图表插入与自动编号功能，支持单图和子图。
- **数学公式**：集成常用数学宏包，搭配 `unicode-math` ，支持复杂公式的排版。
- **参考文献管理**：基于 `biblatex` 宏包，支持 GB/T 7714-2015 国家标准的文献引用格式。
- **结构清晰**：封面、摘要、目录、正文和附录等部分自动生成，无需担心格式问题。

## 使用说明

### 快速开始

#### 1. 配置论文信息

打开 `sdusetup.tex` 文件，填写您的论文信息：

```latex
\Title{在这里键入你的标题}
\Author{你的姓名}
\StudentID{你的学号}
\Department{你的学院}
\Major{你的专业}
\Grade{你的年级}
\Teacher{你的指导教师}
```

#### 2. 编译论文

**方式一：使用构建工具（推荐）**

Linux / macOS:
```bash
make          # 编译论文
make view     # 编译并查看
make clean    # 清理临时文件
```

Windows:
```cmd
build.bat          # 编译论文
build.bat view     # 编译并查看
build.bat clean    # 清理临时文件
```

**方式二：使用 latexmk**

```bash
latexmk -xelatex main.tex    # 编译
latexmk -c                    # 清理临时文件
latexmk -C                    # 清理所有生成文件
```

**方式三：手动编译**

```bash
xelatex main.tex
biber main
xelatex main.tex
xelatex main.tex
```

### 文件命名规范

为了保持项目的整洁性和跨平台兼容性，本模板采用以下文件命名规范：

- **全英文命名**：避免使用中文字符
- **小写字母**：统一使用小写，特殊情况除外
- **下划线分隔**：使用下划线连接多个单词
- **语义化命名**：文件名应清晰表达内容含义

### 编译方式

- **编译方式**：对主源文件 `main.tex` 按照 `xelatex->biber->xelatex->xelatex` 的顺序编译得到输出 PDF 文档 `main.pdf` 。
- **推荐工具**：使用 `make`（Linux/macOS）或 `build.bat`（Windows）或 `latexmk` 自动化编译。
- **使用平台**：
  - （推荐）在中文 Windows 操作系统与较新的 TeXLive 本地发行版环境下，在 Visual Studio Code 中搭配 LaTeX Workshop 扩展使用。`.vscode/settings.json` 中提供了可能会优化使用体验的 Visual Studio Code 局部设置。
  - 在 Overleaf 平台上使用，编译器设置为 `xelatex` ，主文档设置为 `main.tex` ，TeXLive 版本选择较新版即可。注：在 Overleaf 平台上使用时，可能会产生 `fontspec` 宏包的 `Script` 警告，该警告不会对文档的编译造成影响，忽略即可。

### 文档资源

- [PDF 版本说明文档](README.pdf)
- [配置迁移指南 (MIGRATION)](docs/MIGRATION.md) - 从旧版配置升级
- [常见问题解答 (FAQ)](docs/FAQ.md)
- [更新日志 (CHANGELOG)](docs/CHANGELOG.md)
- [使用示例](docs/examples/) - 图片、表格、公式示例
- [开发者文档](docs/developer/README.md)

详细使用方法、配置说明与示例，请参考上述文档。

