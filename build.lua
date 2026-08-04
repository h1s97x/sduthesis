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

-- 测试时模块（.sty）在 modules/ 下，需要加入搜索路径
checksearchpaths = {
  "./modules//",
  "./build/unpacked//",
}

-- 安装到 TeX 目录结构（TDS）的文件
installfiles = {"src/*.cls", "src/*.sty", "modules/*.sty"}

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
