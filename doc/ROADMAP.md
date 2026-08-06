# SDUThesis 项目方案

> 版本：2025-01 | 状态：规划中

---

## 一、项目定位

山东大学本科毕业论文 LaTeX 模板，目标成为山大 LaTeX 社区的事实标准。

核心价值主张：
- **开箱即用** — clone 即编译，零配置门槛
- **插件化** — 内核 + 模块架构，本科/硕士/博士/盲审通过模块切换
- **工程化** — CI/CD 自动编译 + 回归测试 + 自动发版
- **社区化** — CTAN 收录 → TeX Live 自带 → Overleaf 可用

---

## 二、Git 工作流

### 分支模型

```
main (protected)           ← 稳定发布，只接受 release PR
  │
  ├── develop              ← 日常开发基准分支
  │     │
  │     ├── feat/xxx       ← 功能分支
  │     ├── fix/xxx        ← 修复分支
  │     ├── docs/xxx       ← 文档分支
  │     ├── refactor/xxx   ← 重构分支
  │     └── release/vX.Y.Z ← 发布分支
  │
  └── hotfix/vX.Y.Z        ← 紧急修复（从 main 切出）
```

### 分支命名规范

| 类型 | 格式 | 示例 |
|------|------|------|
| 功能 | `feat/<描述>` | `feat/hook-system` |
| 修复 | `fix/<描述>` | `fix/coverpage-alignment` |
| 文档 | `docs/<描述>` | `docs/user-manual` |
| 重构 | `refactor/<描述>` | `refactor/plugin-arch` |
| 发布 | `release/v<版本>` | `release/v1.2.0` |
| 热修 | `hotfix/v<版本>` | `hotfix/v1.1.1` |

### 开发流程

1. 从 `develop` 切功能分支：`git checkout -b feat/xxx develop`
2. 开发完成，提 PR → `develop`
3. CI 自动检查（编译 + 回归测试）
4. Code review（自审，确保 CI 通过 + 代码自检）
5. 合并到 `develop`
6. 发版时从 `develop` 切 `release/vX.Y.Z`，测试通过后合并到 `main` 并打 tag

### 红线

- `main` 分支 protected，不允许直接 push
- 不允许 force push 任何分支
- PR 必须 CI 通过才能合并
- 一个 PR 只做一件事（原子性）

### 提交信息规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/)：

```
<type>(<scope>): <subject>

<body>

<footer>
```

| type | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | 修复 |
| `docs` | 文档 |
| `refactor` | 重构（不改变外部行为） |
| `test` | 测试 |
| `ci` | CI/CD |
| `chore` | 构建/工具 |

---

## 三、插件化架构

### 架构分层

```
┌─────────────────────────────────────────┐
│           用户层 (User Layer)            │
│   sdusetup.tex + data/ + main.tex       │
├─────────────────────────────────────────┤
│         模块层 (Module Layer)            │
│   undergraduate.sty  master.sty  ...    │
│   blindreview.sty    english.sty  ...   │
├─────────────────────────────────────────┤
│           内核 (Core Engine)             │
│   sduthesis.cls                         │
│   ├── SDUSetup 引擎 (l3keys)            │
│   ├── Hook 系统                         │
│   ├── 字体加载器                        │
│   └── 页面引擎                          │
├─────────────────────────────────────────┤
│         基础层 (Base Layer)              │
│   LaTeX3 + ctex + xecjk + biblatex      │
└─────────────────────────────────────────┘
```

### 内核职责

内核 `sduthesis.cls` 只提供三件事：

1. **SDUSetup 引擎** — l3keys 注册表 + Getter 导出机制，任何模块都可以注册新键
2. **Hook 系统** — 在文档编译的各个阶段埋钩子，模块通过钩子注入行为
3. **基础排版** — 页面尺寸、行距、章节编号、页眉页脚框架（不包含具体内容）

### Hook 定义

```latex
% sduthesis.cls 中的 Hook 定义
\NewHook{sduthesis/after-setup}       % SDUSetup 之后
\NewHook{sduthesis/before-cover}      % 封面前
\NewHook{sduthesis/cover-style}       % 封面样式（模块覆盖）
\NewHook{sduthesis/frontmatter/begin} % 前言开始
\NewHook{sduthesis/mainmatter/begin}  % 正文开始
\NewHook{sduthesis/backmatter/begin}  % 后记开始
\NewHook{sduthesis/before-bib}        % 参考文献前
```

### 模块示例

```latex
% modules/undergraduate.sty
\ProvidesPackage{sduthesis-undergraduate}

% 1. 注册本模块特有的 SDUSetup 键
\keys_define:nn { sdu / undergraduate }
{
  supervisor .tl_set:N = \l__sdu_supervisor_tl,
  supervisor .initial:n = { 指导教师 },
}

% 2. 挂载封面钩子
\AddToHook{sduthesis/cover-style}{%
  \sdu_cover_undergraduate:
}

% 3. 挂载前言钩子（承诺书等本科特有内容）
\AddToHook{sduthesis/frontmatter/begin}{%
  \input{modules/data/undergraduate-pledge.tex}
}
```

用户使用：

```latex
% sdusetup.tex
\SDUSetup{
  module = undergraduate,     % 加载本科模块
  title = {论文题目},
  author = {张三},
}
```

### 模块清单

| 模块 | 文件 | 功能 |
|------|------|------|
| `undergraduate` | `modules/sduthesis-undergraduate.sty` | 本科论文封面、声明页、摘要格式 |
| `master` | `modules/sduthesis-master.sty` | 硕士论文封面、答辩委员会等 |
| `doctor` | `modules/sduthesis-doctor.sty` | 博士论文封面、独创声明等 |
| `blindreview` | `modules/sduthesis-blindreview.sty` | 盲审模式（隐藏作者/导师信息） |
| `english` | `modules/sduthesis-english.sty` | 英文论文模式 |

### 架构演进对比

```
v1.x（现在）                           v2.0（目标）
─────────────                         ────────────
sduthesis.cls (18行)                  sduthesis.cls (~150行，内核+Hook)
config/config-main.tex (285行)        ├── 引擎：SDUSetup + Hook + 字体加载器
config/config-coverpage.tex (60行)    │   （不含任何具体排版逻辑）
config/config-abstract.tex (41行)     │
config/...                            modules/
                                        ├── sduthesis-undergraduate.sty
                                        ├── sduthesis-master.sty
                                        ├── sduthesis-blindreview.sty
                                        └── sduthesis-english.sty
```

---

## 四、CI/CD 流水线

### PR 检查流程

```
PR 提交 → ci.yml 自动触发
  │
  ├── 1. 静态检查
  │     └── explcheck（LaTeX 代码规范检查）
  │
  ├── 2. 编译测试
  │     ├── TeX Live 2024 + undergraduate 模块
  │     ├── TeX Live 2024 + master 模块（如有）
  │     └── TeX Live 2023（兼容性）
  │
  ├── 3. 回归测试
  │     └── PDF diff（与 baseline 对比，检测非预期变化）
  │
  └── 4. 产物上传
        └── main.pdf 作为 artifact
```

### Release 流程

```
tag 推送 → release.yml
  ├── 编译全部模块
  ├── git-cliff 生成 CHANGELOG
  ├── 打包 TDS 格式
  └── 创建 GitHub Release + 上传 PDF + TDS
```

---

## 五、版本路线图

### v1.0.0 — 基础功能 ✅

- 本科毕业论文模板可用
- CI 自动编译
- LPPL-1.3c 协议

### v1.1.0 — 基础夯实 🔄

| 改动 | 状态 |
|------|------|
| SDUSetup 完善并导出 Getter | ✅ |
| 统一封面配置 | ✅ |
| tl_packages 补全 | ✅ |
| 清理遗留文件 | ✅ |
| INTERNALS.md 技术文档 | ✅ |
| develop 分支建立 | ✅ |
| CI 通过 | ⏳ |

**交付物**：CI 通过后打 v1.1.0 tag

### v1.2.0 — Hook 系统 + 使用手册

| 改动 | 分支 |
|------|------|
| 在 cls 中引入 Hook 系统（`\NewHook`） | `feat/hook-system` |
| 将现有本科逻辑重构为 undergraduate 模块 | `feat/undergraduate-module` |
| 编写 sduthesis-doc.pdf 使用手册 | `docs/user-manual` |
| Issue/PR 模板 | `feat/issue-template` |

**这是架构转型的关键版本** — 引入 Hook + 模块化，但对外接口不变。

**交付物**：sduthesis-doc.pdf + Hook 系统 + 模块化

### v1.3.0 — 质量保证

| 改动 | 分支 |
|------|------|
| 回归测试框架（PDF diff） | `feat/regression-test` |
| 多版本 TeX Live 矩阵 | `feat/test-matrix` |
| explcheck 静态检查 | `feat/explcheck` |
| Overleaf 兼容性验证 | `feat/overleaf` |

**交付物**：CI 包含回归测试 + Overleaf 模板链接

### v2.0.0 — CTAN 发布

| 改动 | 分支 |
|------|------|
| DTX 格式重写 | `refactor/dtx` |
| master 模块 | `feat/master-module` |
| blindreview 模块 | `feat/blindreview` |
| TDS 打包脚本 | `feat/tds-package` |
| CTAN 提交 | — |

**交付物**：CTAN 收录 + TeX Live 自带 `sduthesis`

---

## 六、v2.0.0 完整文件树

```
sduthesis/
├── src/                              # DTX 源码
│   ├── sduthesis.dtx                 # 内核源码 + 文档注释
│   └── sduthesis.ins                 # 安装脚本
│
├── modules/                          # 功能模块
│   ├── sduthesis-undergraduate.sty   # 本科论文
│   ├── sduthesis-master.sty          # 硕士论文
│   ├── sduthesis-doctor.sty          # 博士论文
│   ├── sduthesis-blindreview.sty     # 盲审模式
│   └── sduthesis-english.sty         # 英文模式
│
├── templates/                        # 用户模板
│   ├── undergraduate/
│   │   ├── main.tex
│   │   ├── sdusetup.tex
│   │   └── data/
│   ├── master/
│   │   └── ...
│   └── blind-review/
│       └── ...
│
├── tests/                            # 测试
│   ├── test-compile.py               # 编译测试
│   ├── test-diff.py                  # PDF diff 回归
│   └── baselines/                    # 基准 PDF
│
├── doc/                              # 文档
│   ├── sduthesis-doc.tex             # 手册源码
│   ├── INTERNALS.md                  # 内部实现文档
│   └── DEVELOP.md                    # 开发指南
│
├── scripts/                          # 工具脚本
│   └── ctan-pack.sh                  # CTAN 打包
│
├── .github/
│   ├── workflows/
│   │   ├── ci.yml                    # PR 检查（编译+回归）
│   │   └── release.yml              # 发版
│   ├── tl_packages
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.yml
│       └── feature_request.yml
│
├── justfile                          # 构建脚本
├── cliff.toml                        # changelog 配置
├── README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
└── LICENSE
```

---

## 七、简历亮点提炼

| 层面 | 具体内容 | 面试表述 |
|------|----------|---------|
| LaTeX3 编程 | l3keys 键值系统、expl3 编程接口、token 变量管理 | "基于 LaTeX3 l3keys 机制设计了 `\SDUSetup{}` 集中配置接口，支持分组键值对，取代传统 `\newcommand` 分散配置" |
| 插件化架构 | Hook 系统 + 模块加载机制 | "设计内核+模块的插件化架构，内核通过 Hook 系统提供扩展点，本科/硕士/博士等不同论文类型作为独立模块加载" |
| 工程化 | CI/CD 自动编译+回归测试+自动发版 | "搭建完整 CI/CD 流水线，实现 xelatex→biber→xelatex 编译链自动化、PDF diff 回归测试、git-cliff 自动生成 CHANGELOG" |
| 开源发布 | LPPL 协议、CTAN 发布、TDS 规范 | "遵循 LaTeX 社区规范，按 LPPL-1.3c 协议开源，发布至 CTAN 进入 TeX Live 发行版" |
| 项目架构 | 模板/示例分离、配置/样式/内容三层解耦 | "将模板架构设计为 config（配置层）→ styles（样式层）→ data（内容层）三层解耦，用户只需修改 data/ 和 `\SDUSetup{}` 即可完成论文写作" |

---

## 八、对标分析与下一步计划（2026-08，Issue #6）

> 调研来源：GitHub 主流高校 LaTeX 学位论文模板库（含 BIThesis、ThuThesis 等），结合 sduthesis v2.0.0 现状给出四 Phase 路线图。

### 8.1 头部标杆

| 项目 | Star | 覆盖范围 | 与 sduthesis 最相关的点 |
|---|---|---|---|
| [tuna/thuthesis](https://github.com/tuna/thuthesis) | 5.4k | 本/硕/博/博后 | DTX + **biblatex/bibtex 双方案** + l3build 回归（`.tlg` 基线规范）| CTAN/TeX Live 收录 |
| [BITNP/BIThesis](https://github.com/BITNP/BIThesis) | 1.2k | 本科/硕博/外文翻译/实验报告/幻灯片 | **架构最像**：内核+模块、`\SetupStyle{}` 集中配置、盲审一键导出、在线 Wiki 文档站 + DeepWiki AI 问答 |
| [stone-zeng/fduthesis](https://github.com/stone-zeng/fduthesis) | 1.0k | 本/硕/博 | **DTX 包编写最佳实践**典范，l3build 双引擎测试 |
| [sjtug/SJTUThesis](https://github.com/sjtug/SJTUThesis) | 3.8k | 本/硕/博 | 文档类与示例分离、Overleaf/TeXPage 多入口官方模板 |
| [TheNetAdmin/zjuthesis](https://github.com/TheNetAdmin/zjuthesis) | 3.7k | 本/硕/博+英文 | 配置项极多（Degree/Type/Period/BlindReview 全放 `\documentclass` 选项） |
| [hithesis/hithesis](https://github.com/hithesis/hithesis) | 2.4k | 一校三区本/硕/博+博后 | 规范文档全表格化收录、Docker/TinyTeX 容器化 CI |
| [ustctug/ustcthesis](https://github.com/ustctug/ustcthesis) | 2.1k | 本/硕/博 | 同走 DTX + l3build 路线，双引用方案 |
| [Liam0205/sduthesis](https://github.com/Liam0205/sduthesis) | 87 | 硕博向 | 同校竞品，说明山大有真实需求，值得持续关注 |

### 8.2 差距分析

sduthesis 已具备（✅ 超越多数同类）：DTX 格式、内核+模块 Hook 架构、`\SDUSetup{}` 集中配置、quality/build/release 三段 CI + l3build 回归门禁 + TeX Live 2025/2026 矩阵、CTAN 打包、LPPL-1.3c。

| 维度 | 头部标杆做法 | sduthesis 现状 |
|---|---|---|
| 模块覆盖 | thuthesis/zjuthesis/hithesis 覆盖本+硕+博 | 仅 undergraduate + blindreview |
| 引用方案 | thuthesis/ustcthesis 维护 biblatex+bibtex 两套 | 仅 biblatex/biber |
| 回归测试深度 | thuthesis testfiles 按页面/宏包细分（几十个 `.tlg`） | testfiles 尚未提交基线 |
| 文档/社区 | BIThesis 在线 Wiki + DeepWiki；thuthesis Discussions | 仅 README + doc/*.md |
| 在线协作 | SJTUThesis 等维护 Overleaf/TeXPage 官方模板 | 仅 snip_uri 跳转 |
| 规范溯源 | hithesis 官方规范全表格化 | 仅一份《撰写规范》引用 |

### 8.3 四 Phase 路线图

**Phase 0 — 立即（P0，1~2 个月，冲刺 v2.1/2.2）** ✅ 已完成（2026-08-06）

1. ✅ 补齐 l3build 回归基线：提交 `testfiles/*.tlg`（cover/abstract/toc/bib/blindreview/master/master-blindreview 共 7 个），并修复 testfiles 无 `\START/\END` 导致基线为空的根因。
2. ✅ 新增 master 模块：硕博封面 + 答辩委员会页，模板升级为学位论文级；并支持 `module={master, blindreview}` 多模块组合加载。
3. ✅ 发布 v2.1.0：CNB 平台原生发布（tag_push 流水线：texlive 镜像编译 + `git:release` + 附件上传），产物 main.pdf / sduthesis.zip / sduthesis.tds.zip / sduthesis-doc.pdf 完整，v2.1.0 已设为 latest release；tag 已通过 git-sync（push_tags）同步至 GitHub 并触发 release.yml。

**Phase 1 — 中期（P1，3~6 个月）** 进行中（2026-08-06）

4. ✅ **Overleaf/TeXPage 官方模板**：仓库根目录即在线模板（main.tex + sdusetup.tex + data/ + modules/ + figures/），新增 `latexmkrc`（XeLaTeX + biber 自动收敛）；`scripts/build-overleaf.sh` 生成 `sduthesis-overleaf.zip`（只含编译所需文件），本地已用 latexmk 完整验证（28 页）。使用说明见 `doc/OVERLEAF.md`。
5. 🚧 **CTAN 提交**：提交材料已就绪——`README`（纯文本）、`scripts/build-ctan.sh` 生成 `sduthesis-ctan.zip`（dtx + ins + modules + README + LICENSE + doc.pdf + tds.zip），TDS 包已通过 `just ctan` 本地验证；待维护者到 https://ctan.org/upload 提交（清单见 `doc/CTAN-SUBMISSION.md`）。收录后 TeX Live 自带，用户门槛骤降。
6. （可选）bibtex 兼容层：biblatex 是趋势，不必跟 thuthesis 双方案；可对齐 `biblatex-gb7714-2015` 配置。
7. 文档站/社区：GitHub Pages + MkDocs 或 VitePress 托管使用手册；Discussions 做问答沉淀。

**Phase 2 — 长期（P2，1 年）**

8. 多学位矩阵 CI：master/doctor 模块加入 build.yml 编译矩阵。
9. 英文模块 / 外文翻译模板（对标 BIThesis）。
10. 开源治理：Issue/PR 模板 + CODE_OF_CONDUCT；等 star 上来后争取官方背书。

> 一句话：工程化架构已可对标 BIThesis/fduthesis，缺的不是架构，是"覆盖面"与"生态"——优先补齐 master 模块 + l3build 基线 + Overleaf 官方模板 + CTAN 提交。
