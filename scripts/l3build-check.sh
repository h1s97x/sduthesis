#!/usr/bin/env bash
# l3build 回归门禁：对比 tlg 基线，防 LaTeX 输出回归
#
# 用法：
#   bash scripts/l3build-check.sh [push|pr]
#
# 说明（回归门禁策略，与 quality.yml 同步）：
#   - 已提交 tlg 基线 → l3build check（对比输出，防回归）
#   - 基线缺失（首次新增测试）→ save 生成基线并上传 artifact；
#     PR 放行（便于贡献者首次引入基线），push 到 develop 则硬失败，
#     强制提醒提交基线，避免 check 长期空转（回归门禁形同虚设）。
#   - 按测试名逐个区分：新增测试（如 master）只 save 新基线，
#     不影响已有基线测试的 check 对比（否则 check 会因缺 tlg 全挂）。
#   - pipefail 保证 l3build 失败时 job 真正失败（不再被 continue-on-error 掩盖）
#   - 注意：l3build save 失败时 PR 场景**放行**（便于贡献者本地修复后重试），
#     push 场景则硬失败（强制提交基线）。故对 save 单独容错，避免 set -e 在
#     PR 下把「save 失败」误判为 job 失败。
#
# 入参：
#   $1 触发事件（push / pr）：push 时缺失基线硬失败（退出码 1），pr 时放行。
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$PWD"
EVENT="${1:-pr}"

cd "$ROOT"

# 读取测试文件列表（不带 .tex 后缀）
mapfile -t tests < <(ls testfiles/*.tex 2>/dev/null | sed 's|testfiles/||; s|\.tex$||' | sort)
if [ "${#tests[@]}" -eq 0 ]; then
  echo "::warning::未找到任何测试文件（testfiles/*.tex）"
  exit 0
fi

missing=()
check_tests=()
for t in "${tests[@]}"; do
  if [ ! -f "testfiles/$t.tlg" ]; then
    missing+=("$t")
  else
    check_tests+=("$t")
  fi
done

if [ "${#missing[@]}" -gt 0 ]; then
  # 首次新增测试：为缺失基线的测试生成基线。
  # save 失败时不要触发 set -e 直接退出：PR 放行、push 仍硬失败。
  if l3build save --quiet "${missing[@]}" 2>&1 | tail -20; then
    echo "::warning::以下测试缺少 tlg 基线，已重新生成（可从 l3build-tlg artifact 下载并提交）: ${missing[*]}"
  else
    echo "::warning::以下测试缺少 tlg 基线且 l3build save 生成失败: ${missing[*]}"
  fi

  if [ "$EVENT" = "push" ]; then
    echo "::error::push 到 develop 必须已提交 tlg 基线（见上方 artifact）。回归门禁在基线提交前不生效。"
    exit 1
  fi
fi

if [ "${#check_tests[@]}" -gt 0 ]; then
  l3build check --quiet "${check_tests[@]}" 2>&1 | tail -40
fi
