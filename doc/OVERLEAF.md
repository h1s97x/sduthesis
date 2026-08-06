# Overleaf / TeXPage 官方模板使用说明

## 在线模板（已就绪）

SDUThesis 提供两种在线使用方式，均已本地编译验证：

1. **Git 导入（推荐）**：Overleaf 支持直接 git 导入 GitHub 仓库
   - Overleaf → New Project → **Import from GitHub** → `h1s97x/sduthesis`
   - 仓库根目录即完整模板（main.tex + sdusetup.tex + data/ + modules/ + figures/ + latexmkrc）
2. **Zip 上传**：运行 `scripts/build-overleaf.sh` 生成 `sduthesis-overleaf.zip`，
   在 Overleaf/TeXPage 中 **Upload Project** 上传即可

## 项目设置（关键）

导入后务必确认以下设置（否则编译会失败或异常）：

| 设置项 | 值 |
|---|---|
| **Compiler** | `XeLaTeX` |
| **Main document** | `main.tex` |
| TeX Live version | 2024 或更新 |

## latexmkrc 的作用

仓库根目录的 `latexmkrc` 是 Overleaf 官方模板的标配：

```perl
$pdf_mode = 5;     # XeLaTeX 引擎
$bibtex_use = 2;   # 使用 biber（biblatex 后端）
```

Overleaf 用 latexmk 驱动编译，读取该配置后：
- 自动选用 XeLaTeX（无需在 UI 反复切换）
- 自动运行 biber 处理参考文献（biblatex-gb7714-2015）
- 自动重跑至交叉引用/目录收敛（最多 6 次）

## 常见问题

**Q: 为什么在 Overleaf 上编译报 `module = {undergraduate}` 未定义？**
A: 检查 `sdusetup.tex` 中 `module` 键是否拼写正确，且编译器为 XeLaTeX。
   Overleaf 的 TeX Live 环境需为 2020+（模板基于 `expl3` 与 `ctexbook`）。

**Q: Overleaf 找不到 `sduthesis.cls`？**
A: 确认 `sduthesis.cls` 位于项目根目录（zip 模板中已包含）。
   若使用 git 导入且未包含该文件，请先本地 `just gen` 生成后提交。

**Q: 参考文献不显示？**
A: 确认使用 biber（latexmkrc 已配置），且未将 Compiler 误设为 pdfLaTeX。
   biblatex-gb7714-2015 仅支持 XeLaTeX/LuaLaTeX + biber。
