# 设计决策记录

> [返回首页](./README.md) | [上一节：开发指南](./development.md)

---

## 设计决策记录

| 决策 | 选择 | 原因 |
|------|------|------|
| 配置机制 | l3keys | LaTeX3 标准，支持分组、默认值、类型检查 |
| 配置键组织（v2.2.0） | `info`/`option` 嵌套分组 + 平铺兼容 | 语义清晰，同时兼容旧写法 |
| 架构 | 内核 + 模块 | 解耦论文类型，方便扩展 |
| 扩展机制 | `\NewHook` / `\AddToHook` | LaTeX3 标准钩子，比 `\AtBeginDocument` 更精确 |
| 字体 | Fandol | TeX Live 自带，CI 和最小安装环境都能用 |
| 参考文献样式 | `gb7714-2015` | 符合国标 GB/T 7714-2015 |
| 参考文献后端 | biber（非 bibtex） | biblatex 是趋势，biber 是其原生后端 |
| 构建工具 | just | 比 Make 语法更简洁，跨平台 |
| DTX 格式 | docstrip | LaTeX 社区标准，CTAN 发布就绪 |
| 编译器 | XeLaTeX | 完美支持中文与 Unicode |
| 盲审回退位置 | 内核加载器（非盲审模块） | 与书写顺序无关，避免耦合 |
| 测试基线 | `.tlg` 提交到仓库 | `l3build check` 才真正生效，缺失时 PR 放行、push 硬失败 |
| TeX Live 缓存 | 不显式传 `repository`（quality/release） | 自动选择镜像，长期命中缓存 |
| TeX Live 矩阵 | 显式指定镜像（build） | 确定性验证旧版本兼容性 |
| lint 范围 | 不检查 `main.tex` | 避免递归 `\input` 到 `data/`，模板 CI 不对用户内容做 gate |
| 版本协议 | LPPL-1.3c | LaTeX 社区标准协议 |

---

## 附录：关键文件速查

| 文件 | 一句话说明 | 文档链接 |
|------|-----------|----------|
| [src/sduthesis.dtx](file:///workspace/src/sduthesis.dtx) | 内核源码 + 使用手册（DTX 格式） | [INTERNALS.md](file:///workspace/doc/INTERNALS.md) |
| [sduthesis.cls](file:///workspace/sduthesis.cls) | docstrip 生成的内核（不要手编） | — |
| [modules/sduthesis-undergraduate.sty](file:///workspace/modules/sduthesis-undergraduate.sty) | 本科论文模块 | — |
| [modules/sduthesis-master.sty](file:///workspace/modules/sduthesis-master.sty) | 硕士论文模块 | — |
| [modules/sduthesis-blindreview.sty](file:///workspace/modules/sduthesis-blindreview.sty) | 盲审叠加层模块 | — |
| [main.tex](file:///workspace/main.tex) | 编译入口 | — |
| [sdusetup.tex](file:///workspace/sdusetup.tex) | 用户配置 | — |
| [justfile](file:///workspace/justfile) | 构建脚本 | — |
| [build.lua](file:///workspace/build.lua) | l3build 配置 | — |
| [latexmkrc](file:///workspace/latexmkrc) | latexmk 配置（Overleaf 用） | [OVERLEAF.md](file:///workspace/doc/OVERLEAF.md) |
| [.chktexrc](file:///workspace/.chktexrc) | chktex lint 规则 | — |
| [tests/test-compile.py](file:///workspace/tests/test-compile.py) | 编译冒烟测试 | — |
| [scripts/l3build-check.sh](file:///workspace/scripts/l3build-check.sh) | 回归门禁逻辑 | — |
| [.github/workflows/quality.yml](file:///workspace/.github/workflows/quality.yml) | 代码质量 CI | [CI-TROUBLESHOOTING.md](file:///workspace/doc/CI-TROUBLESHOOTING.md) |
| [.github/workflows/build.yml](file:///workspace/.github/workflows/build.yml) | 构建 PDF CI | — |
| [.github/workflows/release.yml](file:///workspace/.github/workflows/release.yml) | 发布 CI | — |
| [.cnb.yml](file:///workspace/.cnb.yml) | CNB 流水线 | — |

---

*本文档由代码分析自动生成，基于仓库 v2.2.0 版本。如需了解最新实现，请直接阅读源码与 [doc/INTERNALS.md](file:///workspace/doc/INTERNALS.md)。*
