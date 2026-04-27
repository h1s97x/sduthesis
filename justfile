# SDUThesis Justfile
# 山东大学本科毕业论文 LaTeX 模板编译脚本

# 变量
TEX := "xelatex"
BIBER := "biber"
TARGET := "main"
FLAGS := "-synctex=1 -interaction=nonstopmode -halt-on-error"

# 默认目标
default: build

# 编译 PDF
build:
    @echo "=== 第1次编译 (XeLaTeX) ==="
    {{TEX}} {{FLAGS}} {{TARGET}}.tex
    @echo "=== 处理参考文献 (Biber) ==="
    {{BIBER}} {{TARGET}}
    @echo "=== 第2次编译 (XeLaTeX) ==="
    {{TEX}} {{FLAGS}} {{TARGET}}.tex
    @echo "=== 第3次编译 (XeLaTeX) ==="
    {{TEX}} {{FLAGS}} {{TARGET}}.tex
    @echo "=== 编译完成: {{TARGET}}.pdf ==="

# 编译（别名）
@just build

# 清理辅助文件
clean:
    #!/bin/bash
    echo "清理辅助文件..."
    rm -f {{TARGET}}.aux {{TARGET}}.bbl {{TARGET}}.blg
    rm -f {{TARGET}}.log {{TARGET}}.out {{TARGET}}.synctex.gz
    rm -f {{TARGET}}.toc {{TARGET}}.lot {{TARGET}}.lof
    rm -f {{TARGET}}.fls {{TARGET}}.fdb_latexmk
    rm -f {{TARGET}}-blx.bib
    echo "清理完成"

# 完全清理
distclean: clean
    #!/bin/bash
    echo "清理 PDF 文件..."
    rm -f {{TARGET}}.pdf
    echo "清理完成"

# 编译并打开 PDF
view: build
    #!/bin/bash
    case "$(uname)" in
        Darwin) open {{TARGET}}.pdf ;;
        Linux) xdg-open {{TARGET}}.pdf ;;
        MINGW*) start {{TARGET}}.pdf ;;
        CYGWIN*) cygstart {{TARGET}}.pdf ;;
    esac

# 仅编译（无消息）
silent:
    @{{TEX}} {{FLAGS}} {{TARGET}}.tex
    @{{BIBER}} {{TARGET}}
    @{{TEX}} {{FLAGS}} {{TARGET}}.tex
    @{{TEX}} {{FLAGS}} {{TARGET}}.tex

# 使用 biber 处理参考文献
bib:
    {{BIBER}} {{TARGET}}

# 完整编译流程（带日志）
log: build
    #!/bin/bash
    {{TEX}} {{FLAGS}} {{TARGET}}.tex 2>&1 | tee {{TARGET}}.log
    {{BIBER}} {{TARGET}}
    {{TEX}} {{FLAGS}} {{TARGET}}.tex 2>&1 | tee -a {{TARGET}}.log
    {{TEX}} {{FLAGS}} {{TARGET}}.tex 2>&1 | tee -a {{TARGET}}.log

# 帮助信息
help:
    @echo "SDUThesis Justfile"
    @echo ""
    @echo "用法:"
    @echo "  just              编译 PDF"
    @echo "  just build        编译 PDF（完整输出）"
    @echo "  just clean        清理辅助文件"
    @echo "  just distclean    清理所有生成文件（包括 PDF）"
    @echo "  just view         编译并打开 PDF"
    @echo "  just bib          仅处理参考文献"
    @echo "  just help         显示帮助信息"
