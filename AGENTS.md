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
| `build.yml` | 构建 PDF 包（main.pdf artifact，TeX Live 2025/2026 双版本矩阵） | push main / 手动 |
| `release.yml` | tag 发布（zip/TDS/CTAN + changelog） | tag `v*` |

约定：

- **TeX Live 缓存**：`zauguin/install-texlive@v4` 默认自动缓存 `~/texlive`，跨 workflow 复用，无需额外配置；改包列表 `tl_packages` / `tl_packages_lint` 会自然导致缓存失效重建。
- **TeX Live 安装（关键）**：**不要显式传 `repository`**——显式指定时缓存 key 按天刷新（每天全量重装），且安装版本由该 repository 决定（`texlive_version` 仅进缓存 key、不控制版本，旧 CI 的矩阵因此全装成了当前版）。不传 `repository` 时 action 自动从官方镜像列表选（USA Alive 优先、按镜像 revision 缓存，长期命中），且不会遇到 `mirror.ctan.org` 随机重定向的坏镜像（如 cicku.me 曾致 checksum 失败）。`quality.yml` / `release.yml` 均采用自动选择（装当前版）。仅 `build.yml` 矩阵显式指定镜像以确定性验证旧版本：2026 → MIT `tlnet/`、2025 → tu-chemnitz 历史版 `tlnet-final/`。
- **路径过滤**：`quality.yml` 含 `testfiles/**`、`tests/**`；`build.yml` 不含（测试改动不触发构建）。
- **l3build 基线（回归门禁）**：`testfiles/*.tlg` 为回归对比基线，**提交到仓库后 `check` 才真正生效**；缺失时 PR 运行会 `save` 生成并上传 artifact（放行），**push 到 develop 则硬失败**强制提醒提交基线。新贡献者首次引入基线是 PR 清单的必做项。
- **lint 规则**：排除规则固化在 `.chktexrc`（CmdLine 块），本地与 CI 行为一致；chktex 有 warning 即 CI 失败（gate），不要用 `|| true` 绕过。**新增排除规则前必须本地跑 `chktex -q sduthesis.cls modules/*.sty sdusetup.tex` 验证零 warning**。
- **lint 范围**：只检查模板代码（cls / modules/*.sty / sdusetup.tex），**不检查 `main.tex`**——chktex 会递归 `\input` 到 `data/`（用户论文内容），模板 CI 不对用户内容做 gate。
- **l3build 定位**：testfiles 为编译冒烟测试（l3build 默认不跑 biber）；**参考文献的真实验证由 `test-compile.py`（xelatex → biber → xelatex×2）和 `just build` 覆盖**。
- **版本兼容性**：PR 阶段 lint/regression 用当前版（自动选择）提速；旧 TeX Live 兼容性由 `build.yml` 的 2025/2026 矩阵在 main 分支兜底（矩阵项各自显式指定与版本匹配的镜像地址，确保版本真实生效）。
- **禁止**在 CI 步骤中给检查命令加 `continue-on-error` / `|| true` 掩盖失败；管道输出需 `set -o pipefail` 防止退出码被吞。

## 修改 CI 的注意点

- 新增/调整 paths 过滤时，确保 workflow 自身文件（`.github/workflows/*.yml`）与依赖的包文件（`.github/tl_packages*`）也纳入对应触发路径。
- 两个 workflow 的 TeX 环境安装步骤保持参数一致（texlive_version / repository），以共享缓存。
