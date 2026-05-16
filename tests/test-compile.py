#!/usr/bin/env python3
"""SDUThesis 编译测试脚本

功能：
1. 编译主文档，检查是否成功
2. 检查输出 PDF 是否存在且非空
3. 检查日志中是否有严重错误（Undefined control sequence 等）

用法：
  python3 tests/test-compile.py
"""

import subprocess
import sys
import os
import re

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MAIN_TEX = os.path.join(PROJECT_ROOT, "main.tex")
MAIN_PDF = os.path.join(PROJECT_ROOT, "main.pdf")
MAIN_LOG = os.path.join(PROJECT_ROOT, "main.log")


def run_cmd(cmd, cwd=None):
    """运行命令并返回 (returncode, stdout, stderr)"""
    result = subprocess.run(
        cmd, cwd=cwd or PROJECT_ROOT,
        capture_output=True, text=True, timeout=300
    )
    return result.returncode, result.stdout, result.stderr


def compile_document():
    """完整编译流程：xelatex → biber → xelatex × 2"""
    commands = [
        ["xelatex", "-interaction=nonstopmode", "-halt-on-error", "main.tex"],
        ["biber", "main"],
        ["xelatex", "-interaction=nonstopmode", "-halt-on-error", "main.tex"],
        ["xelatex", "-interaction=nonstopmode", "-halt-on-error", "main.tex"],
    ]

    for i, cmd in enumerate(commands, 1):
        print(f"  [{i}/4] {' '.join(cmd)}")
        rc, stdout, stderr = run_cmd(cmd)
        if rc != 0:
            print(f"  ❌ 命令失败 (exit {rc}): {' '.join(cmd)}")
            # 输出最后 20 行错误
            if stderr:
                for line in stderr.strip().split("\n")[-20:]:
                    print(f"    {line}")
            return False

    return True


def check_pdf():
    """检查 PDF 是否存在且非空"""
    if not os.path.exists(MAIN_PDF):
        print("  ❌ main.pdf 不存在")
        return False

    size = os.path.getsize(MAIN_PDF)
    if size < 1000:
        print(f"  ❌ main.pdf 过小 ({size} bytes)，可能损坏")
        return False

    print(f"  ✅ main.pdf 正常 ({size:,} bytes)")
    return True


def check_log_errors():
    """检查日志中是否有严重错误"""
    if not os.path.exists(MAIN_LOG):
        print("  ⚠️ main.log 不存在，跳过日志检查")
        return True

    with open(MAIN_LOG, "r", encoding="utf-8", errors="replace") as f:
        log_content = f.read()

    # 检查严重错误
    fatal_patterns = [
        (r"^! Undefined control sequence", "Undefined control sequence"),
        (r"^! Missing", "Missing"),
        (r"^! LaTeX Error", "LaTeX Error"),
        (r"^! Emergency stop", "Emergency stop"),
        (r"^! Font", "Font error"),
    ]

    errors = []
    for pattern, label in fatal_patterns:
        matches = re.findall(pattern, log_content, re.MULTILINE)
        if matches:
            errors.append(f"{label} (×{len(matches)})")

    if errors:
        print(f"  ❌ 日志中发现错误: {', '.join(errors)}")
        # 输出第一个错误的上下文
        for pattern, label in fatal_patterns:
            match = re.search(pattern, log_content, re.MULTILINE)
            if match:
                start = max(0, match.start() - 50)
                end = min(len(log_content), match.end() + 200)
                print(f"    上下文: ...{log_content[start:end].strip()}...")
                break
        return False

    # 检查 overfull hbox 警告数量
    overfull = len(re.findall(r"Overfull \\hbox", log_content))
    if overfull > 50:
        print(f"  ⚠️ Overfull hbox 较多 ({overfull})，建议检查排版")

    print("  ✅ 日志检查通过")
    return True


def check_references():
    """检查参考文献是否正确解析（无 ?? 引用）"""
    if not os.path.exists(MAIN_PDF):
        return True

    # 通过 log 检查是否有 undefined reference
    if not os.path.exists(MAIN_LOG):
        return True

    with open(MAIN_LOG, "r", encoding="utf-8", errors="replace") as f:
        log_content = f.read()

    undefined_ref = re.findall(r"LaTeX Warning: Citation .+ undefined", log_content)
    if undefined_ref:
        print(f"  ❌ 有 {len(undefined_ref)} 个未定义引用")
        return False

    print("  ✅ 参考文献检查通过")
    return True


def main():
    print("=" * 50)
    print("SDUThesis 编译测试")
    print("=" * 50)

    all_pass = True

    # 1. 编译
    print("\n📋 步骤 1: 编译文档")
    if not compile_document():
        all_pass = False
    else:
        print("  ✅ 编译成功")

    # 2. PDF 检查
    print("\n📋 步骤 2: 检查 PDF")
    if not check_pdf():
        all_pass = False

    # 3. 日志检查
    print("\n📋 步骤 3: 检查日志")
    if not check_log_errors():
        all_pass = False

    # 4. 引用检查
    print("\n📋 步骤 4: 检查引用")
    if not check_references():
        all_pass = False

    # 汇总
    print("\n" + "=" * 50)
    if all_pass:
        print("✅ 所有测试通过")
        sys.exit(0)
    else:
        print("❌ 测试失败")
        sys.exit(1)


if __name__ == "__main__":
    main()
