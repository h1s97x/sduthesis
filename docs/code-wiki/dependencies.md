# 依赖关系

> [返回首页](./README.md) | [上一节：API 参考](./api-reference.md) | [下一节：运行方式](./usage.md)

---

## LaTeX 宏包依赖

内核在 [src/sduthesis.dtx](file:///workspace/src/sduthesis.dtx) 中 `\usepackage` 加载的宏包：

| 宏包 | 用途 |
|------|------|
| `expl3` + `l3keys2e` | LaTeX3 编程接口与键值系统 |
| `ctexbook` | 基础文档类（中文支持，作为 `\LoadClass` 加载） |
| `xeCJK` | CJK 字符处理 |
| `amsmath` / `amsthm` / `amsfonts` / `amssymb` / `unicode-math` | 数学排版 |
| `xcolor` | 颜色 |
| `geometry` | 页面尺寸 |
| `float` | 浮动体控制 |
| `fancyhdr` | 页眉页脚 |
| `setspace` | 行距 |
| `bookmark` | PDF 书签 |
| `booktabs` | 三线表 |
| `graphicx` | 图片 |
| `caption` / `subfig` | 图表标题与子图 |
| `listings` | 代码排版 |
| `tocloft` | 目录样式 |
| `biblatex` (biber, gb7714-2015) | 参考文献 |
| `hyperref` | 超链接 |
| `etoolbox` | 工具宏（`\AtBeginEnvironment` 等） |
| `tabularx` | 可变宽度表格 |
| `algorithmicx` / `algorithm` / `algpseudocode` | 算法排版 |

---

## 模块依赖关系

```
内核 sduthesis.cls
  ├── 加载 → ctexbook（基础文档类）
  ├── 加载 → 所有宏包（见上文）
  ├── 定义 → SDUSetup 引擎 + Hook 系统
  └── \AtBeginDocument 时调用 \sdu_load_module:
        │
        ├── 若含 blindreview 且无基础模块 → 前置加载 undergraduate
        │
        └── 按用户指定顺序加载：
            ├── sduthesis-undergraduate.sty （本科基础模块）
            │     └── 覆盖 \makecoverpage / cnabstract / ...
            │
            ├── sduthesis-master.sty （硕士基础模块）
            │     └── 覆盖 \makecoverpage / \makecommittee / ...
            │
            └── sduthesis-blindreview.sty （盲审叠加层，最后加载覆盖 Getter）
                  └── 覆盖 \GetAuthor → *** / \GetStudentId → *** / ...
```

**加载时序关键点**：
- 模块加载发生在 `\AtBeginDocument`（即 `\begin{document}` 时），早于 `main.tex` 中的任何排版命令
- 后加载的模块覆盖先加载的（盲审模块放最后，覆盖 Getter）
- 模块加载后触发 `sduthesis/after-setup` Hook

---

## CI 依赖（TeX Live 包）

定义在 [.github/tl_packages](file:///workspace/.github/tl_packages)，按 collection 整组安装避免传递依赖遗漏：

| 类别 | 包 |
|------|-----|
| 编译基础 | `scheme-minimal`, `collection-latex`, `collection-xetex`, `latexmk`, `chktex`, `l3build` |
| 中文支持 | `ctex` |
| 参考文献 | `biber`, `biblatex`, `biblatex-gb7714-2015` |
| 模板使用 | `collection-latexextra`, `collection-latexrecommended`, `collection-fontsrecommended`, `collection-mathscience` |
| 独立包 | `algorithmicx` |
| 传递依赖 | `logreq`, `zhnumber` |

精简 lint 环境（[.github/tl_packages_lint](file:///workspace/.github/tl_packages_lint)）：`scheme-small` + `collection-binextra`（仅 chktex）。

---

## 构建工具依赖

| 工具 | 用途 | 安装 |
|------|------|------|
| `just` | 构建脚本执行器 | `brew install just` / `cargo install just` |
| `latexmk` | 自动化编译（Overleaf 同款） | TeX Live 自带 |
| `l3build` | LaTeX 包回归测试 | TeX Live 自带 |
| `chktex` | LaTeX 代码静态检查 | TeX Live 自带 |
| `xelatex` | 编译器 | TeX Live 自带 |
| `biber` | 参考文献处理器 | TeX Live 自带 |
| `git-cliff` | CHANGELOG 生成（release 用） | `taiki-e/install-action` |
| `python3` | 测试脚本 | 系统自带 |
