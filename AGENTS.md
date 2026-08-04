# AGENTS.md

## 项目概览

山东大学毕业论文 LaTeX 模板（sduthesis）。核心源码为 DTX 格式（`src/sduthesis.dtx`），通过 `xelatex sduthesis.ins` 生成 `sduthesis.cls`；可选模块位于 `modules/`（盲审、本科等）。

## 常用命令（justfile）

- `just build`：编译 main.pdf（xelatex ×3 + biber）
- `just test`：编译 + 运行 `tests/test-compile.py`
- `just lint`：chktex 代码检查（规则见 `.chktexrc`）
- `just gen`：从 DTX 生成 `sduthesis.cls`
- `just doc`：编译开发者文档 `sduthesis-doc.pdf`
- `just tds` / `just ctan`：打包 CTAN 发布格式

## CI 结构（GitHub Actions）

| Workflow | 职责 | 触发 |
|---|---|---|
| `quality.yml` | 代码质量：chktex lint（精简环境）+ 编译回归（test-compile + l3build） | PR / push develop，仅代码路径 |
| `build.yml` | 构建 PDF 包（main.pdf artifact） | push main / 手动 |
| `release.yml` | tag 发布（zip/TDS/CTAN + changelog） | tag `v*` |

约定：

- **TeX Live 缓存**：`zauguin/install-texlive@v4` 默认自动缓存 `~/texlive`，跨 workflow 复用，无需额外配置；改包列表 `tl_packages` / `tl_packages_lint` 会自然导致缓存失效重建。
- **路径过滤**：`quality.yml` 含 `testfiles/**`、`tests/**`；`build.yml` 不含（测试改动不触发构建）。
- **l3build 基线**：`testfiles/*.tlg` 为回归对比基线，提交到仓库后 `check` 才真正生效；缺失时 CI 会 `save` 生成并提示下载提交。
- **lint 规则**：排除规则固化在 `.chktexrc`（CmdLine 块），本地与 CI 行为一致；chktex 有 warning 即 CI 失败（gate），不要用 `|| true` 绕过。
- **禁止**在 CI 步骤中给检查命令加 `continue-on-error` / `|| true` 掩盖失败；管道输出需 `set -o pipefail` 防止退出码被吞。

## 修改 CI 的注意点

- 新增/调整 paths 过滤时，确保 workflow 自身文件（`.github/workflows/*.yml`）与依赖的包文件（`.github/tl_packages*`）也纳入对应触发路径。
- 两个 workflow 的 TeX 环境安装步骤保持参数一致（texlive_version / repository），以共享缓存。
