# SDUT thesis Justfile
# 山东大学本科毕业论文 LaTeX 模板

# 变量
tex := "xelatex"
biber := "biber"
target := "main"
flags := "-synctex=1 -interaction=nonstopmode -halt-on-error"

# 默认目标
default: build

# 编译 PDF
build:
    #!/usr/bin/env bash
    set -e
    echo "=== 第1次编译 (XeLaTeX) ==="
    {{tex}} {{flags}} {{target}}.tex
    echo "=== 处理参考文献 (Biber) ==="
    {{biber}} {{target}}
    echo "=== 第2次编译 (XeLaTeX) ==="
    {{tex}} {{flags}} {{target}}.tex
    echo "=== 第3次编译 (XeLaTeX) ==="
    {{tex}} {{flags}} {{target}}.tex
    echo "=== 编译完成: {{target}}.pdf ==="

# 清理辅助文件
clean:
    #!/usr/bin/env bash
    rm -f {{target}}.aux {{target}}.bbl {{target}}.blg {{target}}.log
    rm -f {{target}}.out {{target}}.synctex.gz {{target}}.toc
    rm -f {{target}}.lot {{target}}.lof {{target}}.fls
    rm -f {{target}}.fdb_latexmk {{target}}-blx.bib

# 完全清理
distclean: clean
    rm -f {{target}}.pdf

# 编译并打开 PDF (Linux)
open-linux: build
    xdg-open {{target}}.pdf

# 编译并打开 PDF (macOS)
open-mac: build
    open {{target}}.pdf

# 编译并打开 PDF (Windows)
open-windows: build
    start {{target}}.pdf

# 查看 PDF（自动检测系统）
view: build
    #!/usr/bin/env bash
    case "$(uname -s)" in
        Darwin*)  open {{target}}.pdf ;;
        Linux*)   xdg-open {{target}}.pdf ;;
        MINGW*|MSYS*) start {{target}}.pdf ;;
    esac

# 帮助
help:
    @echo "SDUT Thesis Justfile"
    @echo ""
    @echo "用法:"
    @echo "  just              编译 PDF（等同于 just build）"
    @echo "  just build        编译 PDF"
    @echo "  just clean        清理辅助文件"
    @echo "  just distclean    清理辅助文件和 PDF"
    @echo "  just view         编译并打开 PDF"
    @echo "  just help         显示帮助"
