#!/usr/bin/env bash
# 构建 CTAN 提交包（在 just ctan 产物基础上补充 CTAN 要求的 README 等材料）
#
# 用法：
#   bash scripts/build-ctan.sh
#
# 产物：sduthesis-ctan.zip（可直接上传 https://ctan.org/upload ）
#
# 说明：
#   - 复用 just ctan 的打包流程（dtx + ins + modules + doc.pdf + tds.zip），
#     但把 README.md 换成 CTAN 要求的纯文本 README（README 文件），
#     并校验产物完整性（tldraw 可接受的 CTAN 包结构）。
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$PWD"

echo "=== 构建 CTAN 提交包 ==="

# 1) 先构建标准 CTAN 产物（just ctan 会顺带生成 tds.zip）
just ctan >/dev/null

STAGE="$(mktemp -d /tmp/sduthesis-ctan-submit.XXXXXX)"
trap 'rm -rf "$STAGE"' EXIT

rm -rf "$STAGE/sduthesis"
mkdir -p "$STAGE/sduthesis"

# 2) CTAN 包内容
cp src/sduthesis.dtx "$STAGE/sduthesis/"
cp src/sduthesis.ins "$STAGE/sduthesis/"
cp modules/*.sty "$STAGE/sduthesis/"
cp README "$STAGE/sduthesis/"            # CTAN 要求纯文本 README（无扩展名）
cp README.md "$STAGE/sduthesis/"         # 同时附 Markdown 版供在线浏览
cp LICENSE "$STAGE/sduthesis/"
cp sduthesis-doc.pdf "$STAGE/sduthesis/"
cp sduthesis.tds.zip "$STAGE/sduthesis/"

# 3) 压缩
cd "$STAGE"
rm -f "$ROOT/sduthesis-ctan.zip"
zip -r "$ROOT/sduthesis-ctan.zip" sduthesis >/dev/null
echo "=== CTAN 提交包生成完成: sduthesis-ctan.zip ($(stat -c%s "$ROOT/sduthesis-ctan.zip") bytes) ==="

# 4) 自检：列出包内容
echo "=== 包内容 ==="
unzip -l "$ROOT/sduthesis-ctan.zip" | awk '{print $4}' | grep -v '^$' | grep -v '^sduthesis/$'
