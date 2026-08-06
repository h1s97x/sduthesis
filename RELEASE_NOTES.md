# sduthesis v2.1.0

山东大学学位论文 LaTeX 模板 —— 从"本科模板"升级为"学位论文模板"。

## 🚀 Features

- 新增 **`master` 模块**（硕博封面 + 答辩委员会页），支持硕士/博士论文
- 支持**多模块组合加载**：`module = {master, blindreview}` 等，按顺序叠加功能
- 新增 `\makecommittee` 答辩委员会页命令，及 `degree` / `committeeChair` / `committeeMembers` / `defenseDate` / `defensePlace` 配置键与对应 Getter
- 盲审回退由内核加载器统一处理，`module` 列表含 `blindreview` 时自动补全基础模块
- 新增 `\IfBlindReviewTF` / `\IfBlindReviewF` 盲审标志命令
- 引入 **l3build 回归测试框架**，补齐 7 个 `.tlg` 基线
- 新增 CNB 流水线（GitHub 同步 + Issue/PR 自动分配处理人）

## 🐛 Bug Fixes

- 修复盲审模式 `\makestatement` 未定义导致的编译报错
- 修复 `build.lua` 配置使 l3build 测试目录可编译
- 修复 CI 首次 `l3build save` 无参数必失败
- 修复 LPPL 许可合规（补齐 cls 与模块版权声明）
- 修复 TeX Live 镜像安装失败（恢复缓存命中、build 矩阵版本真实生效）
- 盲审模式跳过答辩委员会页，避免泄露主席/委员姓名

## 📚 Documentation

- 更新 ROADMAP（对标分析与四 Phase 路线图）
- 同步 DTX / README / sdusetup.tex 多模块用法

## 📦 产物

- `main.pdf` — 模板编译示例
- `sduthesis.zip` — 用户模板包
- `sduthesis.tds.zip` — TDS 规范包（CTAN 发布格式）
- `sduthesis-doc.pdf` — 开发者文档
