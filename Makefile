# SDUThesis Makefile
# 山东大学本科毕业论文 LaTeX 模板编译脚本

TEX := xelatex
BIBER := biber
TARGET := main
SHELL := /bin/bash

# XeLaTeX 编译参数
FLAGS := -synctex=1 -interaction=nonstopmode -halt-on-error

# 默认目标：编译 PDF
.PHONY: all clean distclean view

all: $(TARGET).pdf

# 编译流程：xelatex -> biber -> xelatex -> xelatex
$(TARGET).pdf:
	@echo "=== 第1次编译 (XeLaTeX) ==="
	$(TEX) $(FLAGS) $(TARGET).tex
	@echo "=== 处理参考文献 (Biber) ==="
	$(BIBER) $(TARGET)
	@echo "=== 第2次编译 (XeLaTeX) ==="
	$(TEX) $(FLAGS) $(TARGET).tex
	@echo "=== 第3次编译 (XeLaTeX) ==="
	$(TEX) $(FLAGS) $(TARGET).tex
	@echo "=== 编译完成: $(TARGET).pdf ==="

# 清理辅助文件
clean:
	@echo "清理辅助文件..."
	@rm -f $(TARGET).aux $(TARGET).bbl $(TARGET).blg
	@rm -f $(TARGET).log $(TARGET).out $(TARGET).synctex.gz
	@rm -f $(TARGET).toc $(TARGET).lot $(TARGET).lof
	@rm -f $(TARGET).fls $(TARGET).fdb_latexmk
	@rm -f $(TARGET)-blx.bib
	@echo "清理完成"

# 完全清理（包含 PDF）
distclean: clean
	@echo "清理 PDF 文件..."
	@rm -f $(TARGET).pdf
	@echo "清理完成"

# 使用系统默认程序打开 PDF
view:
ifeq ($(shell uname),Darwin)
	open $(TARGET).pdf
else ifeq ($(shell uname),Linux)
	xdg-open $(TARGET).pdf
else
	start $(TARGET).pdf
endif

# 帮助信息
help:
	@echo "SDUThesis Makefile"
	@echo ""
	@echo "用法:"
	@echo "  make          编译 PDF (xelatex -> biber -> xelatex -> xelatex)"
	@echo "  make clean    清理辅助文件"
	@echo "  make distclean 清理所有生成文件（包括 PDF）"
	@echo "  make view     编译并打开 PDF"
	@echo "  make help     显示帮助信息"
