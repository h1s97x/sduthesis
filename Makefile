# Makefile for SDUThesis
# 山东大学本科毕业论文模板构建工具

THESIS = main
PACKAGE = sduthesis

LATEXMK = latexmk
SHELL := /bin/bash

# Windows 兼容性
ifdef SystemRoot
	RM = del /Q
	OPEN = start
else
	RM = rm -f
	UNAME := $(shell uname -s)
	ifeq ($(UNAME), Darwin)
		OPEN = open
	else
		OPEN = xdg-open
	endif
endif

.PHONY: all build thesis clean cleanall distclean view help

# 默认目标
all: thesis

# 编译论文
thesis: $(THESIS).pdf

build: thesis

$(THESIS).pdf: FORCE_MAKE
	$(LATEXMK) $(THESIS)

# 查看 PDF
view: thesis
	$(OPEN) $(THESIS).pdf

# 清理辅助文件（保留 PDF）
clean:
	$(LATEXMK) -c $(THESIS)
	-@$(RM) *~

# 清理所有生成文件（包括 PDF）
cleanall: clean
	-@$(RM) $(THESIS).pdf

# 完全清理（包括模板生成的文件）
distclean: cleanall
	-@$(RM) *.synctex.gz

# 帮助信息
help:
	@echo "SDUThesis Makefile 使用说明"
	@echo "=============================="
	@echo ""
	@echo "可用目标："
	@echo "  make [all|thesis|build]  - 编译论文（默认）"
	@echo "  make view                - 编译并查看 PDF"
	@echo "  make clean               - 清理辅助文件（保留 PDF）"
	@echo "  make cleanall            - 清理所有生成文件（包括 PDF）"
	@echo "  make distclean           - 完全清理"
	@echo "  make help                - 显示此帮助信息"
	@echo ""
	@echo "编译要求："
	@echo "  - XeLaTeX"
	@echo "  - Biber"
	@echo "  - latexmk（推荐）"
	@echo ""
	@echo "快速开始："
	@echo "  make          # 编译论文"
	@echo "  make view     # 编译并查看"
	@echo "  make clean    # 清理临时文件"

FORCE_MAKE:
