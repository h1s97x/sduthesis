# SDUT Thesis — Overleaf / TeXPage 在线编译配置
#
# Overleaf 使用 latexmk 驱动编译（编译器选择 XeLaTeX）。
# 本模板基于 ctexbook + biblatex(biber)，需要此配置确保：
#   1. 使用 XeLaTeX 引擎（$pdf_mode = 5）
#   2. 参考文献由 biber 处理（biblatex 使用 biber，而非传统 bibtex）
#   3. 自动重跑足够次数以收敛交叉引用/目录/参考文献
#
# 本地使用 latexmk -xelatex main.tex 也会读取本配置，行为与在线一致。

$pdf_mode = 5;            # 5 = xelatex
$bibtex_use = 2;          # 2 = 使用 biber（biblatex 后端）
$max_repeat = 6;          # 重跑上限（交叉引用 + 目录 + 参考文献收敛）
$bibtex_fudge = 1;        # 防止 biber 死循环

# 清理规则（latexmk -c 时移除的辅助文件）
$clean_ext = 'aux bbl bcf blg fdb_latexmk fls lof log lot out run.xml toc xdv';
