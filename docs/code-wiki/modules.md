# 主要模块职责

> [返回首页](./README.md) | [上一节：整体架构](./architecture.md) | [下一节：API 参考](./api-reference.md)

---

## 内核（`sduthesis.cls` / `src/sduthesis.dtx`）

内核只提供四件事，**不包含任何论文类型特有的排版逻辑**：

| 职责 | 说明 |
|------|------|
| **SDUSetup 引擎** | 基于 l3keys 的键值注册表 + Getter 导出机制 |
| **Hook 系统** | 在文档编译各阶段埋入 6 个钩子 |
| **模块加载器** | `\sdu_load_module:` 解析逗号分隔的模块列表并按顺序加载，含盲审回退逻辑 |
| **基础排版** | 页面尺寸、行距、章节编号、字体、参考文献、图表标题、代码排版引擎 |

内核提供的"占位命令"在未被模块覆盖时会发出警告：

| 占位项 | 类型 | 默认行为 |
|--------|------|----------|
| `\makecoverpage` | 命令 | 发出 `PackageWarning`（请加载模块） |
| `\makestatement` | 命令 | 发出 `PackageWarning` |
| `\makecommittee` | 命令 | 发出 `PackageWarning` |
| `cnabstract` | 环境 | 空实现 `{}` `{}` |
| `enabstract` | 环境 | 空实现 `{}` `{}` |
| `\cnkeywords` | 命令 | 空参数 `#1` |
| `\enkeywords` | 命令 | 空参数 `#1` |

内核定义的通用环境（不依赖模块）：

| 环境/命令 | 职责 |
|-----------|------|
| `myacknowledgement` | 致谢环境（含目录条目、页眉处理） |
| `myappendix` | 附录环境（切换 `\appendix` 编号、附录公式/表/图编号带章节前缀） |
| `\printbib` | 参考文献打印（`\chapter*{参考文献}` + `\printbibliography`） |
| `\maketable` | 目录（罗马页码、定制目录样式、书签） |

---

## 模块层

| 模块 | 文件 | 类型 | 通过何种方式加载 |
|------|------|------|------------------|
| `undergraduate` | `modules/sduthesis-undergraduate.sty` | 基础模块（默认） | `\SDUSetup{module=undergraduate}` |
| `master` | `modules/sduthesis-master.sty` | 基础模块 | `\SDUSetup{module=master}` |
| `blindreview` | `modules/sduthesis-blindreview.sty` | 叠加层模块 | `\SDUSetup{module={master,blindreview}}` |

### `undergraduate` 模块职责

- 覆盖 `\makecoverpage`：本科封面（校徽、校名、论文题目、姓名/学号/学院/专业/指导教师表格、年月）
- 覆盖 `cnabstract` / `enabstract` 环境：中英文摘要格式（标题、缩进、字号）
- 覆盖 `\cnkeywords` / `\enkeywords`：关键词样式
- 注入 Hook：
  - `sduthesis/frontmatter/begin` → 前言空白页眉页脚
  - `sduthesis/mainmatter/begin` → 正文页眉"山东大学本科毕业论文（设计）" + 1.3 行距
  - `sduthesis/backmatter/begin` → 后记章标题小二号居中加粗

### `master` 模块职责

- 覆盖 `\makecoverpage`：硕士封面（与本科类似，新增"学位类型"行）
- 覆盖 `\makecommittee`：**答辩委员会页**（主席/委员/答辩日期/答辩地点，盲审时整页跳过）
- 覆盖摘要环境与关键词（与 undergraduate 一致）
- 注入 Hook：正文页眉为"山东大学硕士学位论文"
- 新增配置键（在内核已注册）：`degree` / `committeeChair` / `committeeMembers` / `defenseDate` / `defensePlace`

### `blindreview` 模块职责（叠加层）

盲审模块**不定义封面版式**，通过三层机制隐藏个人信息：

1. **设置盲审标志**：`\bool_set_true:N \l__sdu_blindreview_bool`（基础模块封面通过 `\IfBlindReviewF` 决定是否输出个人信息行）
2. **覆盖 Getter**：将 `\GetAuthor` / `\GetStudentId` / `\GetSupervisor` / `\GetCommitteeChair` / `\GetCommitteeMembers` 全部覆写为 `***`，摘要/致谢等处的作者名同样被隐藏
3. **跳过整页**：`\makestatement` 置空（跳过声明页）、`\makecommittee` 置空（跳过答辩委员会页，避免泄露主席/委员姓名）

**盲审回退**：若 `module` 列表含 `blindreview` 但缺少基础模块（`undergraduate`/`master`），内核加载器会**自动前置加载本科模块**，与书写顺序无关（如 `{blindreview, master}` 只加载 `master` 一个基础模块）。

---

## 用户层

| 文件 | 职责 |
|------|------|
| `main.tex` | 编译入口，组装前言/正文/附录/后记结构 |
| `sdusetup.tex` | 用户配置，调用 `\SDUSetup{}` 设置论文信息与模块 |
| `data/frontmatter/` | 摘要、致谢、附录内容 |
| `data/chapters/` | 正文章节（chapter1~5） |
| `data/ref/references.bib` | BibTeX 参考文献数据库 |
| `figures/` | 图片资源（含 `logos/` 校徽校名） |
