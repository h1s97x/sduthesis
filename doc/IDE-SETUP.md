# IDE 配置指南

本文档介绍如何配置常见的 LaTeX 编辑器以使用 sduthesis 模板。

## 目录

- [Visual Studio Code](#visual-studio-code)
- [其他 IDE](#其他-ide)

---

## Visual Studio Code

VS Code 配合 LaTeX Workshop 扩展是推荐的本地编辑方案。

### 安装扩展

1. 打开 VS Code
2. 按 `Ctrl+P` 打开快速打开
3. 输入 `ext install James-Yu.latex-workshop`
4. 点击安装

### 推荐配置

将以下配置添加到 `~/.vscode/settings.json`（用户全局设置）或项目内的 `.vscode/settings.json`：

```json
{
    "latex-workshop.latex.autoBuild.run": "onSave",
    "latex-workshop.latex.outDir": "%DIR%",
    
    "latex-workshop.latex.tools": [
        {
            "name": "xelatex",
            "command": "xelatex",
            "args": [
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "%DOC%"
            ]
        },
        {
            "name": "biber",
            "command": "biber",
            "args": ["%DOCFILEBASE%"]
        },
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": [
                "-xelatex",
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "%DOC%"
            ]
        }
    ],
    
    "latex-workshop.latex.recipes": [
        {
            "name": "xelatex -> biber -> xelatex*2",
            "tools": ["xelatex", "biber", "xelatex", "xelatex"]
        },
        {
            "name": "latexmk (自动化)",
            "tools": ["latexmk"]
        }
    ],
    
    "latex-workshop.latex.defaultRecipe": "xelatex -> biber -> xelatex*2",
    "latex-workshop.view.pdf.viewer": "tab"
}
```

### 编译快捷键

- **编译**：`Ctrl+Alt+B`
- **查看 PDF**：`Ctrl+Alt+V`
- **清理临时文件**：`Ctrl+Alt+C`

### Tasks 配置

在 `.vscode/tasks.json` 中添加：

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "完整编译",
            "type": "shell",
            "command": "bash",
            "args": ["-c", "xelatex main.tex && biber main && xelatex main.tex && xelatex main.tex"],
            "group": "build"
        },
        {
            "label": "清理临时文件",
            "type": "shell",
            "command": "bash",
            "args": ["-c", "rm -f *.aux *.bbl *.bcf *.blg *.log *.out *.synctex.gz *.toc"]
        }
    ]
}
```

---

## 其他 IDE

### TeXworks

TeXworks 是跨平台的 LaTeX 编辑器，适合初学者。

**配置步骤**：
1. 编辑 → 首选项 → 编译器
2. 添加新的编译器：
   - 名称：`XeLaTeX`
   - 程序：`xelatex`
   - 参数：`-synctex=1 -interaction=nonstopmode "%W"`

### TeXnicCenter

Windows 平台常用的 LaTeX IDE。

**配置输出配置文件**：
1. 输出 → 输出配置文件
2. 选择 XeLaTeX 作为 LaTeX 编译器
3. 配置 biber 作为参考文献处理器

### Vim / Neovim

使用 `vimtex` 插件：

```vim
" 在 .vimrc 中添加
let g:tex_flavor = 'latex'
let g:vimtex_compiler_latexmk = {
    \ 'options': [
    \   '-xelatex',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
\}
```

### Emacs

使用 `AUCTeX` + `RefTeX`：

```elisp
;; 在 .emacs 中添加
(setq TeX-engine 'xetex)
(setq TeX-PDF-mode t)
(add-hook 'LaTeX-mode-hook 'reftex-mode)
```

---

## 字体配置

如果遇到字体问题，确保系统已安装所需的中文字体：

**Linux (Ubuntu/Debian)**:
```bash
sudo apt install fonts-wqy-microhei fonts-wqy-zenhei
fc-cache -fv
```

**macOS**:
macOS 默认支持中文，如需更多字体可在 Font Book 中添加。

**Windows**:
Windows 自带中文字体，推荐使用：
- Microsoft YaHei (微软雅黑)
- SimSun (宋体)
- SimHei (黑体)
