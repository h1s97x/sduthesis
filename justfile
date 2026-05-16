# SDUT thesis Justfile
# 山东大学毕业论文 LaTeX 模板

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

# 运行编译测试
test: build
    #!/usr/bin/env bash
    python3 tests/test-compile.py

# LaTeX 代码检查
lint:
    #!/usr/bin/env bash
    chktex -eall -n1 -n2 -n8 -n24 -n36 -n44 src/sduthesis.dtx modules/*.sty main.tex sdusetup.tex 2>/dev/null || true
    @echo "--- lint 完成 ---"

# 从 DTX 生成 cls（开发用）
gen:
    #!/usr/bin/env bash
    set -e
    echo "=== 从 DTX 生成 sduthesis.cls ==="
    cd src && xelatex sduthesis.ins
    cp sduthesis.cls ../sduthesis.cls
    echo "=== 生成完成 ==="

# 编译开发者文档（sduthesis-doc.pdf）
doc:
    #!/usr/bin/env bash
    set -e
    echo "=== 编译开发者文档 ==="
    cd src && xelatex -interaction=nonstopmode sduthesis.dtx
    xelatex -interaction=nonstopmode sduthesis.dtx
    cp sduthesis.pdf ../sduthesis-doc.pdf
    echo "=== 文档生成完成: sduthesis-doc.pdf ==="

# TDS 打包（CTAN 发布格式）
tds:
    #!/usr/bin/env bash
    set -e
    echo "=== 构建 TDS 包 ==="
    just gen
    just doc
    rm -rf /tmp/sduthesis-tds
    mkdir -p /tmp/sduthesis-tds/tex/latex/sduthesis
    mkdir -p /tmp/sduthesis-tds/doc/latex/sduthesis
    mkdir -p /tmp/sduthesis-tds/source/latex/sduthesis
    cp sduthesis.cls /tmp/sduthesis-tds/tex/latex/sduthesis/
    cp modules/*.sty /tmp/sduthesis-tds/tex/latex/sduthesis/
    cp src/sduthesis.dtx /tmp/sduthesis-tds/source/latex/sduthesis/
    cp src/sduthesis.ins /tmp/sduthesis-tds/source/latex/sduthesis/
    cp sduthesis-doc.pdf /tmp/sduthesis-tds/doc/latex/sduthesis/
    cp README.md /tmp/sduthesis-tds/doc/latex/sduthesis/
    cd /tmp/sduthesis-tds && zip -r /tmp/sduthesis.tds.zip tex doc source
    cp /tmp/sduthesis.tds.zip .
    echo "=== TDS 包生成完成: sduthesis.tds.zip ==="

# CTAN 发布包
ctan: tds
    #!/usr/bin/env bash
    set -e
    echo "=== 构建 CTAN 发布包 ==="
    rm -rf /tmp/sduthesis-ctan
    mkdir -p /tmp/sduthesis-ctan
    cp src/sduthesis.dtx /tmp/sduthesis-ctan/
    cp src/sduthesis.ins /tmp/sduthesis-ctan/
    cp modules/*.sty /tmp/sduthesis-ctan/
    cp README.md /tmp/sduthesis-ctan/
    cp LICENSE /tmp/sduthesis-ctan/
    cp sduthesis-doc.pdf /tmp/sduthesis-ctan/
    cp sduthesis.tds.zip /tmp/sduthesis-ctan/
    cd /tmp/sduthesis-ctan && zip -r /tmp/sduthesis-ctan.zip *
    cp /tmp/sduthesis-ctan.zip .
    echo "=== CTAN 发布包生成完成: sduthesis-ctan.zip ==="

# 帮助
help:
    @echo "SDUT Thesis Justfile"
    @echo ""
    @echo "用法:"
    @echo "  just              编译 PDF（等同于 just build）"
    @echo "  just build        编译 PDF"
    @echo "  just test         编译并运行测试"
    @echo "  just lint         LaTeX 代码检查（chktex）"
    @echo "  just gen          从 DTX 生成 cls"
    @echo "  just doc          编译开发者文档"
    @echo "  just tds          构建 TDS 包（CTAN 格式）"
    @echo "  just ctan         构建 CTAN 发布包"
    @echo "  just clean        清理辅助文件"
    @echo "  just distclean    清理辅助文件和 PDF"
    @echo "  just view         编译并打开 PDF"
    @echo "  just help         显示帮助"
