@echo off
REM build.bat - SDUThesis Windows 构建脚本
REM 山东大学本科毕业论文模板

setlocal

set THESIS=main

REM 检查参数
if "%1"=="" goto build
if "%1"=="build" goto build
if "%1"=="clean" goto clean
if "%1"=="cleanall" goto cleanall
if "%1"=="view" goto view
if "%1"=="help" goto help
goto help

:build
echo 正在编译论文...
echo.
latexmk -xelatex %THESIS%.tex
if errorlevel 1 (
    echo.
    echo 编译失败！请检查错误信息。
    pause
    exit /b 1
)
echo.
echo 编译成功！生成文件: %THESIS%.pdf
pause
exit /b 0

:clean
echo 正在清理辅助文件...
latexmk -c %THESIS%.tex
del /Q *~ 2>nul
echo 清理完成！
pause
exit /b 0

:cleanall
echo 正在清理所有生成文件...
latexmk -C %THESIS%.tex
del /Q *~ 2>nul
echo 清理完成！
pause
exit /b 0

:view
echo 正在编译并查看论文...
latexmk -xelatex %THESIS%.tex
if errorlevel 1 (
    echo.
    echo 编译失败！请检查错误信息。
    pause
    exit /b 1
)
start %THESIS%.pdf
exit /b 0

:help
echo SDUThesis Windows 构建脚本
echo ============================
echo.
echo 用法: build.bat [命令]
echo.
echo 可用命令:
echo   build     - 编译论文（默认）
echo   clean     - 清理辅助文件（保留 PDF）
echo   cleanall  - 清理所有生成文件（包括 PDF）
echo   view      - 编译并查看 PDF
echo   help      - 显示此帮助信息
echo.
echo 编译要求:
echo   - XeLaTeX
echo   - Biber
echo   - latexmk（推荐）
echo.
echo 快速开始:
echo   build.bat          # 编译论文
echo   build.bat view     # 编译并查看
echo   build.bat clean    # 清理临时文件
echo.
pause
exit /b 0
