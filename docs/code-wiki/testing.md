# 测试体系

> [返回首页](./README.md) | [上一节：运行方式](./usage.md) | [下一节：CI/CD 流水线](./ci-cd.md)

---

## 测试分层

```
tests/test-compile.py       ← 完整编译测试（xelatex → biber → xelatex×2）
                                检查项：编译成功 + PDF 非空 + 日志无严重错误 + 引用无 ??
testfiles/*.tex + *.tlg     ← l3build 回归测试（输出对比基线，防回归）
```

---

## `tests/test-compile.py` —— 编译冒烟测试

Python 脚本，运行 `just test` 触发，覆盖四项检查：

| 步骤 | 检查内容 |
|------|----------|
| 1. 编译 | xelatex → biber → xelatex × 2 四次编译是否成功 |
| 2. PDF | `main.pdf` 是否存在且非空（>1000 bytes） |
| 3. 日志 | `main.log` 中是否有 `Undefined control sequence` / `Missing` / `LaTeX Error` / `Emergency stop` / `Font error` |
| 4. 引用 | 是否有 `Citation undefined`（参考文献未解析，会显示 `??`） |

---

## `testfiles/` —— l3build 回归测试

测试用例使用 `.tex` 扩展名（非 l3build 默认 `.lvt`，通过 `build.lua` 的 `lvtext = ".tex"` 配置）：

| 测试文件 | 测试内容 |
|----------|----------|
| `cover.tex` | 本科封面排版 |
| `abstract.tex` | 中英文摘要环境 |
| `toc.tex` | 目录生成 |
| `bib.tex` | 参考文献引用（`\citing` + `\printbib`） |
| `appendix.tex` | 附录编号（A/B/C）与"无空白页"行为（守护历史 bug PR #12） |
| `master.tex` | 硕士封面 + 答辩委员会页 |
| `blindreview.tex` | 本科 + 盲审组合（隐私断言） |
| `master-blindreview.tex` | 硕士 + 盲审组合（隐私断言） |
| `nested-setup.tex` | 嵌套 `info`/`option` 分组写法与平铺写法等价性断言（v2.2.0） |

### 测试机制

```latex
% testfiles/cover.tex 示例
\documentclass{sduthesis}
\input{setup-test}        % 公共配置（testfiles/support/setup-test.tex）
\input{regression-test}   % l3build 测试框架（提供 \START \END \ASSERT \TYPE）

\begin{document}
\START
\makecoverpage
\END
\end{document}
```

- `testfiles/support/setup-test.tex`：所有测试共用的 `\SDUSetup{}` 配置
- 每个 `.tex` 编译后产生输出，与同名 `.tlg` 基线对比
- `.tlg` 是回归基线，**提交到仓库后 `l3build check` 才真正生效**

### 盲审测试的断言式校验

[testfiles/blindreview.tex](file:///workspace/testfiles/blindreview.tex) 通过 `\ASSERT` 显式断言隐私保护：

```latex
\ASSERT{\GetAuthor}{***}          % Getter 必须被掩码
\ASSERT{\GetStudentId}{***}
\ASSERT{\GetSupervisor}{***}
% 封面个人信息行在盲审模式下必须为空（行宽检测）
\setbox0=\hbox{\IfBlindReviewF{姓名:张某某 学号:202100100001 导师:李某某}}
\ifdim\wd0=0pt \TYPE{personal-row-hidden=YES}\else\TYPE{personal-row-hidden=NO}\fi
```

---

## l3build 配置（[build.lua](file:///workspace/build.lua)）

```lua
module = "sduthesis"
supportdir = "./testfiles/support"
sourcefiles = {"src/*.dtx", "src/*.ins"}
unpackdir = "./build/unpacked"
-- 通过 tdsdirs 暴露模板依赖给隔离的测试目录
tdsdirs = {
  ["./modules"]         = "tex/latex/sduthesis",
  ["./build/unpacked"]  = "tex/latex/sduthesis",
  ["./figures"]         = "tex/latex/sduthesis/figures",
}
checkengines = {"xetex"}    -- 只测 XeTeX 引擎
checkopts = "-file-line-error -halt-on-error -interaction=nonstopmode"
lvtext = ".tex"             -- 测试文件用 .tex 扩展名
```

---

## 回归门禁策略

由 [scripts/l3build-check.sh](file:///workspace/scripts/l3build-check.sh) 实现，区分 push / pr 两种触发事件：

| 场景 | 行为 |
|------|------|
| 测试已有 `.tlg` 基线 | `l3build check` 对比输出，有差异则失败 |
| 测试缺失基线（PR 场景） | `l3build save` 生成基线并上传 artifact，**放行**（便于贡献者首次引入基线） |
| 测试缺失基线（push 到 develop） | `l3build save` 后**硬失败**，强制提醒提交基线 |

关键约束：
- `set -euo pipefail` 保证 l3build 失败时 job 真正失败（不被管道吞掉退出码）
- 对 `save` 单独容错：PR 场景 `save` 失败也放行，push 场景硬失败
