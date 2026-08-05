#!/usr/bin/env texlua

-- l3build configuration for SDUThesis
-- Reference: https://github.com/tuna/thuthesis (build.lua)

module = "sduthesis"

-- 测试支持文件目录（放测试用到的公共 .tex 文件）
supportdir = "./testfiles/support"

-- DTX 源码在 src/ 目录下，unpack 时需要指定源码路径
-- l3build 的 sourcefiles 是相对于 build.lua 所在目录
unpackdir = "./build/unpacked"
sourcefiles = {"src/*.dtx", "src/*.ins"}

-- 将模块目录、解包目录与图片目录加入 TeX 搜索路径（l3build 的 tdsdirs 机制）。
-- testfiles 在 build/test 隔离目录下编译，必须通过 tdsdirs 暴露模板依赖，
-- 否则 xelatex 找不到 sduthesis.cls / modules/*.sty / figures/。
tdsdirs = {
  ["./modules"]         = "tex/latex/sduthesis",
  ["./build/unpacked"]  = "tex/latex/sduthesis",
  ["./figures"]         = "tex/latex/sduthesis/figures",
}

-- 安装到 TeX 目录结构（TDS）的文件
-- 注意：unpack 产物（sduthesis.cls）直接位于 unpackdir 根目录，
-- 因此 installfiles 相对 unpackdir 引用 *.cls，而非 src/*.cls。
installfiles = {"*.cls", "modules/*.sty"}

-- 文档文件（随包发布）
docfiles = {
  "README.md",
  "CHANGELOG.md",
  "LICENSE",
  "doc",
}

-- 构建产物打包成 .tds.zip
packtdszip = true

-- 指定文件在 TDS 中的正确位置
tdslocations = {
  "tex/latex/sduthesis/*.cls",
  "tex/latex/sduthesis/*.sty",
}

-- 只测试 XeTeX 引擎（论文模板只用 xelatex）
checkengines = {"xetex"}
stdengine = "xetex"

-- 编译选项
-- 注：不开 -shell-escape（testfiles 与 doc 均未使用 minted 等外部工具），收窄执行面
checkopts = "-file-line-error -halt-on-error -interaction=nonstopmode"

-- 忽略某些测试（当前无）
excludetests = {}

-- 测试文件目录
testfiledir = "testfiles"

-- 本项目 testfiles 使用 .tex 扩展名（非 l3build 默认的 .lvt）
-- 测试文件通过 \input{regression-test} + \START/\END 产生可对比的 .tlg 基线
lvtext = ".tex"
