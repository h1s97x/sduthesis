# SDUTHESIS: 山东大学本科毕业论文（理工类）模板

## 简介

`sduthesis` 是为山东大学理工类专业的本科毕业论文而设计的 LaTeX 模板。该模板基于《山东大学本科毕业论文（设计）撰写规范》编写，旨在帮助学生快速、高效地排版本科毕业论文。

## 起源与致谢

本项目基于 [wangzhukang/sduthesis](https://github.com/wangzhukang/sduthesis) 二次开发而来。感谢原作者为山东大学本科毕业论文 LaTeX 模板奠定了良好基础。

本项目在原项目的基础上进行了以下改进：
- 重新组织了项目目录结构，遵循模板与示例分离原则
- 优化了配置文件结构，便于用户定制
- 完善了文档体系，增加了 FAQ 和故障排查指南
- 增加了 GitHub Actions CI/CD，持续集成测试
- 统一使用开源字体，跨平台兼容性更好

## 项目结构

```
sduthesis/
├── sduthesis.cls              # 核心模板类
├── sdusetup.tex              # 用户配置接口
├── main.tex                  # 主文件
├── main.pdf                  # 编译好的示例 PDF
├── Makefile                  # 编译脚本
│
├── data/                     # 论文内容（用户修改这里）
│   ├── frontmatter/          # 封面、摘要、目录
│   ├── chapters/            # 正文
│   └── ref/                 # 参考文献
│       └── references.bib
│
├── config/                   # 格式配置（一般不动）
│   ├── config-main.tex
│   ├── config-coverpage.tex
│   ├── config-abstract.tex
│   ├── config-contents.tex
│   ├── config-bibliography.tex
│   └── config-appendix.tex
│
├── figures/                  # 图片
│   └── logos/               # Logo
│       ├── sdu_logo.pdf
│       └── sdu_title.pdf
│
├── doc/                     # 文档
│   ├── FAQ.md               # 常见问题
│   └── TROUBLESHOOTING.md   # 故障排查
│
├── .github/workflows/       # GitHub Actions
│   ├── build.yml            # CI 编译测试
│   ├── release.yml          # 自动发布
│   └── changelog.yml        # 自动生成 CHANGELOG
│
├── LICENSE                  # LPPL-1.3c
├── CHANGELOG.md
├── CONTRIBUTING.md
└── README.md
```

## 主要功能

- **页面与文本格式**：自动配置符合规范的页面设置、字体和段距
- **图表支持**：提供图表插入与自动编号功能，支持单图和子图
- **数学公式**：集成常用数学宏包，支持复杂公式的排版
- **参考文献管理**：基于 `biblatex` 宏包，支持 GB/T 7714-2015 国家标准
- **结构清晰**：封面、摘要、目录、正文和附录等部分自动生成
- **跨平台兼容**：自动检测系统字体，支持 Windows/macOS/Linux/Overleaf

## 快速开始

### 1. 配置论文信息

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

### 2. 编写论文内容

将您的内容放在 `data/` 目录下：
- `data/frontmatter/` - 封面、摘要等
- `data/chapters/` - 正文章节
- `data/ref/` - 参考文献

### 3. 编译论文

```bash
make          # 编译论文
make view     # 编译并预览
make clean    # 清理临时文件
```

或使用 latexmk：

```bash
latexmk -xelatex main.tex
```

## 使用平台

| 平台 | 编译器 | 说明 |
|------|--------|------|
| Windows/macOS/Linux | xelatex | 推荐使用 TeX Live |
| Overleaf | xelatex | 选择较新版本即可 |

## 文档

- [FAQ](doc/FAQ.md) - 常见问题解答
- [TROUBLESHOOTING](doc/TROUBLESHOOTING.md) - 故障排查指南
- [CHANGELOG](CHANGELOG.md) - 更新日志

## 协议

本项目基于 [LPPL-1.3c](LICENSE) (LaTeX Project Public License) 授权。

核心要求：
- 保持文件完整性
- 修改后必须重命名文件
- 必须保留 LICENSE 和原始来源

## 参与贡献

欢迎提交 Issue 和 Pull Request！请参阅 [CONTRIBUTING.md](CONTRIBUTING.md)。
