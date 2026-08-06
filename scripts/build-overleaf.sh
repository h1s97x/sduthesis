#!/usr/bin/env bash
# 构建 Overleaf Gallery / TeXPage 官方模板 zip 包
#
# 用法：
#   bash scripts/build-overleaf.sh
#
# 产物：sduthesis-overleaf.zip
#
# 说明：
#   - Overleaf 官方模板需要「开箱即用」：zip 内只含编译所需文件，
#     不含 CI 配置、测试基线、DTX 开发源码等与在线编译无关的内容。
#   - 基于仓库根目录（main.tex + sdusetup.tex + data/ + modules/ + figures/）
#     打包，编译行为与 git 导入 Overleaf（snip_uri）一致。
#   - 附带 latexmkrc，确保 XeLaTeX + biber 流程在 Overleaf 上自动收敛。
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$PWD"

STAGE="$(mktemp -d /tmp/sduthesis-overleaf.XXXXXX)"
trap 'rm -rf "$STAGE"' EXIT

echo "=== 构建 Overleaf 模板包 ==="
rm -rf "$STAGE/sduthesis"
mkdir -p "$STAGE/sduthesis"

# 1) 编译入口
cp main.tex sdusetup.tex "$STAGE/sduthesis/"
cp sduthesis.cls "$STAGE/sduthesis/"
cp latexmkrc "$STAGE/sduthesis/"

# 2) 模板核心文件（modules/data/figures）
cp -r modules data figures "$STAGE/sduthesis/"

# 3) 用户文档（README + 常见问题）
cp README.md "$STAGE/sduthesis/"
if [ -f doc/FAQ.md ]; then
  mkdir -p "$STAGE/sduthesis/doc"
  cp doc/FAQ.md "$STAGE/sduthesis/doc/"
fi

# 4) 压缩
cd "$STAGE"
rm -f "$ROOT/sduthesis-overleaf.zip"
zip -r "$ROOT/sduthesis-overleaf.zip" sduthesis >/dev/null
echo "=== Overleaf 模板包生成完成: sduthesis-overleaf.zip ($(stat -c%s "$ROOT/sduthesis-overleaf.zip") bytes) ==="

# 5) 自检：解压并编译验证
echo "=== 自检：解压编译 ==="
rm -rf "$STAGE/check"
mkdir -p "$STAGE/check"
cd "$STAGE/check"
unzip -q "$ROOT/sduthesis-overleaf.zip"
cd sduthesis
latexmk -xelatex -interaction=nonstopmode main.tex >/dev/null 2>&1 || {
  echo "ERROR: Overleaf 模板包编译失败"
  exit 1
}
test -s main.pdf
echo "=== 自检通过: $(stat -c%s main.pdf) bytes ==="
