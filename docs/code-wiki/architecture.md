# 项目整体架构

> [返回首页](./README.md) | [下一节：模块职责](./modules.md)

---

## 四层架构

```
┌─────────────────────────────────────────┐
│           用户层 (User Layer)            │
│   sdusetup.tex + data/ + main.tex       │
├─────────────────────────────────────────┤
│         模块层 (Module Layer)            │
│   undergraduate.sty  master.sty          │
│   blindreview.sty                       │
├─────────────────────────────────────────┤
│           内核 (Core Engine)             │
│   sduthesis.cls                         │
│   ├── SDUSetup 引擎 (l3keys)            │
│   ├── Hook 系统                         │
│   ├── 模块加载器                        │
│   ├── 字体加载器                        │
│   └── 页面/章节/引用引擎                 │
├─────────────────────────────────────────┤
│         基础层 (Base Layer)              │
│   LaTeX3 + ctexbook + xeCJK + biblatex   │
└─────────────────────────────────────────┘
```

**核心设计原则**：内核不知道什么是"本科封面"，只知道"有个 `cover-style` 钩子，谁加载谁负责"。所有论文类型特有的排版逻辑通过模块注入，内核只提供基础设施。

---

## 文件调用链

```
main.tex
├── \documentclass{sduthesis}         ← 加载内核
│   ├── ctexbook                       ← 基础文档类
│   ├── SDUSetup 引擎                  ← l3keys 键值定义 + Getter
│   ├── Hook 定义                      ← \NewHook{sduthesis/*}
│   ├── 字体/页面/章节/引用引擎        ← 基础排版
│   └── 通用环境                       ← myacknowledgement / myappendix / printbib / maketable
│
├── \input{sdusetup.tex}               ← 用户设置 \SDUSetup{module=undergraduate, ...}
│
└── \begin{document}
    ├── \AtBeginDocument               ← 自动加载 sduthesis-<module>.sty
    │   ├── \renewcommand{\makecoverpage}  ← 封面排版
    │   ├── \renewenvironment{cnabstract}  ← 摘要环境
    │   └── \AddToHook{sduthesis/*}        ← 页眉页脚、章节格式
    │
    ├── \frontmatter
    ├── \UseHook{sduthesis/frontmatter/begin}  ← 前言钩子
    ├── \makecoverpage                          ← 封面
    ├── \input{data/frontmatter/abstract.tex}   ← 摘要内容
    ├── \maketable                              ← 目录
    │
    ├── \mainmatter
    ├── \UseHook{sduthesis/mainmatter/begin}   ← 正文钩子
    ├── \input{data/chapters/chapterN.tex}     ← 正文章节
    │
    ├── \begin{myappendix}                     ← 附录（必须在 \backmatter 前）
    │
    ├── \backmatter
    ├── \UseHook{sduthesis/backmatter/begin}  ← 后记钩子
    ├── \printbib                              ← 参考文献
    └── \begin{myacknowledgement}              ← 致谢
```

---

## DTX 源码 → 生成产物

模板核心采用 LaTeX 社区标准的 DTX（Documented TeX）格式：

```
src/sduthesis.dtx  ──[xelatex sduthesis.ins]──>  sduthesis.cls
                  └─[xelatex sduthesis.dtx]──>  sduthesis-doc.pdf（开发者文档）
```

- `src/sduthesis.dtx`：内核源码 + 使用手册（同一文件同时承载代码与文档）
- `src/sduthesis.ins`：docstrip 安装脚本，从 DTX 提取 `.cls`
- `sduthesis.cls`：**生成文件**，由 docstrip 产生，**不要手动编辑**（仓库中已提交以便 Overleaf 直接编译）

---

## 目录结构

```
sduthesis/
├── src/                            # DTX 源码（开发者维护）
│   ├── sduthesis.dtx               #   内核源码 + 使用手册
│   └── sduthesis.ins               #   安装脚本（从 .dtx 提取 .cls）
├── sduthesis.cls                   # 生成文件（从 .dtx 提取，不要手动编辑）
├── sdusetup.tex                    # 用户配置（论文信息 + 模块选择）
├── main.tex                        # 主文件（编译入口）
│
├── modules/                        # 功能模块（插件）
│   ├── sduthesis-undergraduate.sty #   本科论文模块
│   ├── sduthesis-master.sty        #   硕士学位论文模块
│   └── sduthesis-blindreview.sty   #   盲审模式模块（叠加层）
│
├── data/                           # 论文内容（用户编辑区）
│   ├── frontmatter/                #   摘要、致谢、附录
│   ├── chapters/                   #   正文章节（chapter1~5）
│   └── ref/references.bib          #   参考文献数据库
│
├── figures/                        # 图片资源
│   └── logos/                      #   校徽校名（sdu_logo_2.pdf / sdu_title.png）
│
├── testfiles/                      # l3build 回归测试
│   ├── support/setup-test.tex      #   测试公共配置
│   ├── *.tex                       #   测试用例（cover/abstract/toc/bib/...）
│   └── *.tlg                       #   回归对比基线
│
├── tests/
│   └── test-compile.py             # 完整编译测试脚本
│
├── scripts/                        # 工具脚本
│   ├── build-ctan.sh               #   构建 CTAN 提交包
│   ├── build-overleaf.sh           #   构建 Overleaf 模板包
│   └── l3build-check.sh            #   l3build 回归门禁逻辑
│
├── doc/                            # 文档
│   ├── FAQ.md                      #   常见问题
│   ├── INTERNALS.md                #   技术文档（架构与机制）
│   ├── DEVELOP.md                  #   开发指南
│   ├── ROADMAP.md                  #   项目方案与路线图
│   ├── OPTIMIZATION-PLAN.md        #   优化计划
│   ├── OVERLEAF.md                  #   Overleaf 使用说明
│   ├── CTAN-SUBMISSION.md          #   CTAN 提交清单
│   └── CI-TROUBLESHOOTING.md       #   CI 故障排查
│
├── .github/                        # GitHub Actions CI
│   ├── workflows/
│   │   ├── quality.yml             #   代码质量（lint + 回归）
│   │   ├── build.yml               #   构建 PDF（TeX Live 2025/2026 矩阵）
│   │   ├── release.yml             #   tag 发布
│   │   └── sync-cnb.yml            #   GitHub → CNB 反向同步
│   ├── tl_packages                #   完整 TeX Live 包列表
│   ├── tl_packages_lint           #   精简 lint 环境包列表
│   ├── ISSUE_TEMPLATE/            #   Issue 模板
│   ├── PULL_REQUEST_TEMPLATE.md   #   PR 模板
│   └── CODEOWNERS                 #   代码所有者
│
├── .cnb.yml                        # CNB 流水线配置
├── .cnb/web_trigger.yml            # CNB Web 触发器
│
├── justfile                        # 构建脚本（just）
├── build.lua                       # l3build 配置
├── latexmkrc                        # latexmk 配置（Overleaf 用）
├── .chktexrc                       # chktex lint 规则
├── cliff.toml                      # git-cliff changelog 配置
├── README.md / README              # 项目说明（Markdown + 纯文本）
├── CHANGELOG.md                    # 变更日志（git-cliff 生成）
├── RELEASE_NOTES.md                # 发布说明
├── CONTRIBUTING.md                 # 贡献指南
└── LICENSE                         # LPPL-1.3c 协议
```
