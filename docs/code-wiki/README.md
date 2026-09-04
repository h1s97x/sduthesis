# SDUThesis Code Wiki

> 山东大学毕业论文 LaTeX 模板的结构化代码文档
> 版本：v2.2.0 | 协议：LPPL-1.3c | 维护者：h1s97x
> 仓库：https://github.com/h1s97x/sduthesis

---

## 文档导航

| 文档 | 内容 |
|------|------|
| [项目概览](#1-项目概览) | 项目简介、技术栈、核心特性 |
| [整体架构](./architecture.md) | 四层架构、文件调用链、DTX 源码生成、目录结构 |
| [模块职责](./modules.md) | 内核、本科/硕士/盲审模块职责详解 |
| [API 参考](./api-reference.md) | 变量、核心函数、Hook 系统、字体/引用/章节引擎 |
| [依赖关系](./dependencies.md) | 宏包依赖、模块依赖、CI 依赖、构建工具 |
| [运行方式](./usage.md) | 编译流程、用户配置、在线编辑、开发者命令 |
| [测试体系](./testing.md) | 编译冒烟测试、l3build 回归测试、门禁策略 |
| [CI/CD 流水线](./ci-cd.md) | GitHub Actions 三段式、CNB 流水线、路径过滤 |
| [开发指南](./development.md) | 开发流程、命名规范、扩展方法、关键约束 |
| [设计决策](./design-decisions.md) | 设计决策记录、关键文件速查 |

---

## 1. 项目概览

### 1.1 项目简介

`sduthesis` 是为山东大学学位论文设计的 LaTeX 模板，基于《山东大学本科毕业论文（设计）撰写规范》编写。模板采用 **内核 + 模块** 的插件化架构，通过 `\SDUSetup{}` 集中配置，支持本科、硕士、博士等不同学位类型论文，并支持盲审模式。

### 1.2 技术栈

| 层级 | 技术 |
|------|------|
| 编程范式 | LaTeX3 (expl3) 编程接口 |
| 配置机制 | l3keys 键值系统 |
| 扩展机制 | LaTeX Hook 系统（`\NewHook` / `\AddToHook`） |
| 编译器 | XeLaTeX |
| 中文支持 | ctex + xeCJK + Fandol 开源字体 |
| 参考文献 | biblatex + biber + gb7714-2015 样式 |
| 构建工具 | just + latexmk + l3build |
| CI/CD | GitHub Actions + CNB 流水线 |
| 版本控制 | Git（GitHub + CNB 双向同步） |
| 协议 | LPPL-1.3c (LaTeX Project Public License) |

### 1.3 核心特性

- **插件化架构**：内核提供基础排版引擎和 Hook 系统，模块负责特定论文类型的格式和内容
- **集中配置**：通过 `\SDUSetup{}` 统一管理论文信息与样式，内容与样式分离；支持 `info={...}` / `option={...}` 嵌套分组与平铺两种写法（v2.2.0+）
- **多模块组合**：`module` 键支持逗号分隔的模块列表（如 `{master, blindreview}`），按顺序加载实现功能叠加
- **盲审模式**：隐藏作者、学号、导师、答辩委员会成员等个人信息
- **跨平台**：支持 Windows / macOS / Linux / Overleaf / TeXPage
- **开源字体**：使用 TeX Live 自带的 Fandol 字体，无需额外安装
- **自动化 CI/CD**：GitHub Actions 三段式流水线（质量检查 / 构建 / 发布）

---

*本文档由代码分析自动生成，基于仓库 v2.2.0 版本。如需了解最新实现，请直接阅读源码与 [doc/INTERNALS.md](file:///workspace/doc/INTERNALS.md)。*
