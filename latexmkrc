# latexmkrc for SDUThesis
# 山东大学本科毕业论文模板 latexmk 配置文件

# 使用 XeLaTeX + xdvipdfmx 模式
$pdf_mode = 5;

# XeLaTeX 编译命令
$xelatex = "xelatex -shell-escape -file-line-error -halt-on-error -interaction=nonstopmode -no-pdf -synctex=1 %O %S";

# xdvipdfmx 转换命令
$xdvipdfmx = "xdvipdfmx -q -E -o %D %O %S";

# 使用 Biber 处理参考文献
$bibtex_use = 1.5;

# 清理时删除的额外文件扩展名
$clean_ext = "hd loe ptc run.xml synctex.gz thm xdv";

# 自动运行次数（确保交叉引用正确）
$max_repeat = 5;

# 出错时不删除输出文件
$force_mode = 1;

# 设置输出目录（可选，注释掉则在当前目录）
# $out_dir = "build";

# 预览器设置（根据操作系统自动选择）
if ($^O eq 'MSWin32') {
    # Windows
    $pdf_previewer = 'start %S';
} elsif ($^O eq 'darwin') {
    # macOS
    $pdf_previewer = 'open %S';
} else {
    # Linux
    $pdf_previewer = 'xdg-open %S';
}

# 连续预览模式
$preview_continuous_mode = 1;

# 静默模式（减少输出）
$silent = 0;

# 警告处理
$warnings_as_errors = 0;
