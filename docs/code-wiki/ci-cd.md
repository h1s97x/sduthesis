# CI/CD 流水线

> [返回首页](./README.md) | [上一节：测试体系](./testing.md) | [下一节：开发指南](./development.md)

---

## GitHub Actions 三段式

| Workflow | 文件 | 职责 | 触发 |
|----------|------|------|------|
| **Quality** | [.github/workflows/quality.yml](file:///workspace/.github/workflows/quality.yml) | 代码质量：chktex lint（精简环境）+ 编译回归（test-compile + l3build） | PR / push develop，仅代码路径 |
| **Build** | [.github/workflows/build.yml](file:///workspace/.github/workflows/build.yml) | 构建 PDF 包（main.pdf artifact，TeX Live 2025/2026 双版本矩阵） | push main / 手动 |
| **Release** | [.github/workflows/release.yml](file:///workspace/.github/workflows/release.yml) | tag 发布（zip/TDS/CTAN + CHANGELOG） | tag `v*` |
| **Sync-CNB** | [.github/workflows/sync-cnb.yml](file:///workspace/.github/workflows/sync-cnb.yml) | GitHub → CNB 反向同步 | push main，仅模板代码路径 |

---

## Quality Workflow

```
checkout
  ├── lint job（精简环境，约 1 分钟）
  │     ├── install-texlive（tl_packages_lint，仅 chktex）
  │     └── chktex -q sduthesis.cls modules/*.sty sdusetup.tex
  │
  └── regression job（完整环境）
        ├── install-texlive（tl_packages）
        ├── link fonts（XeTeX 字体目录符号链接）
        ├── install just
        ├── gen cls（从 DTX 提取）
        ├── python3 tests/test-compile.py（编译 + 检查）
        ├── bash scripts/l3build-check.sh ${{ github.event_name }}（回归门禁）
        └── upload-artifact: l3build-tlg（缺失基线时上传）
```

**lint 关键约定**：
- 排除规则固化在 [.chktexrc](file:///workspace/.chktexrc)（CmdLine 块），本地与 CI 行为一致
- 有 warning 即 CI 失败（gate），**不要用 `|| true` 绕过**
- 范围：只检查模板代码（`cls` / `modules/*.sty` / `sdusetup.tex`），**不检查 `main.tex`**（避免递归 `\input` 到 `data/` 对用户内容做 gate）

**chktex 排除规则**（`.chktexrc`）：

| 规则 | 说明 | 排除原因 |
|------|------|----------|
| `-n 1` | 命令后跟空格 | — |
| `-n 6` | 斜体修正缺失 | 字体声明宏（`\songti\itshape`）误报 |
| `-n 8` | 连字符长度 | `gb7714-2015`、参考文献页码合法用法 |
| `-n 13` | 句间空格 | — |
| `-n 24` | 删除多余空格 | `\left` / `\right` 后空格误报 |
| `-n 26` | 标点前空格 | expl3 l3keys 属性列表对齐空格误报 |
| `-n 36` | 其他已知误报 | — |

---

## Build Workflow

```
checkout
  └── matrix（TeX Live 2025 + 2026）
        ├── install-texlive（显式指定与版本匹配的镜像）
        ├── link fonts
        ├── install just
        ├── gen cls
        ├── just build
        ├── verify PDF（test -s main.pdf）
        └── upload-artifact: main.pdf (TeX Live <version>)
```

**TeX Live 矩阵配置（关键）**：

| 版本 | repository | 说明 |
|------|------------|------|
| 2026 | `https://mirrors.mit.edu/CTAN/systems/texlive/tlnet/` | MIT 镜像（当前版） |
| 2025 | `https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2025/tlnet-final/` | 历史版 |

**关键决策**：仅 `build.yml` 矩阵显式指定镜像以确定性验证旧版本；`quality.yml` / `release.yml` 不传 `repository`，由 action 自动从官方镜像列表选（USA Alive 优先、按镜像 revision 缓存，长期命中）。

---

## Release Workflow

```
checkout（fetch-tags）
  ├── install-texlive
  ├── link fonts
  ├── install just + git-cliff
  ├── gen cls
  ├── just build
  ├── just doc
  ├── git-cliff --config cliff.toml --output CHANGELOG.md
  ├── commit + push CHANGELOG.md [skip ci]
  ├── create zip archive（main.tex + sdusetup.tex + cls + modules + data + figures + 文档）
  ├── just tds（创建 TDS 包）
  └── softprops/action-gh-release（上传 main.pdf / sduthesis.zip / sduthesis.tds.zip / sduthesis-doc.pdf）
```

**关键约束**：`CHANGELOG.md` 不在任何 workflow 的触发 `paths` 中（避免 release push CHANGELOG 触发连锁 CI）。

---

## CNB 流水线（[.cnb.yml](file:///workspace/.cnb.yml)）

CNB（cnb.cool）平台的原生流水线，与 GitHub 形成双向同步：

| 事件 | 流水线 | 行为 |
|------|--------|------|
| `main.push` | `sync-to-github` | CNB → GitHub 同步（`sync_mode: rebase`，保留 GitHub 平台文件） |
| `pull_request` | `auto-assign-pr-owner` | PR 创建后自动分配处理人 + 审查人 |
| `$.web_trigger_pull_from_github` | `web-trigger-pull-from-github` | 手动触发：GitHub → CNB 拉取（`sync_mode: pull`） |
| `$.issue.open` | `auto-assign-issue-owner` | Issue 创建后自动分配处理人（cnb-cli） |
| `$.tag_push` | `release-sduthesis` | tag 发布：texlive 镜像编译 + `git:release` + 附件上传 |

**防同步环**：`sync-cnb.yml` 的 paths 排除 `.cnb*` / `.cnb/` / `.github/**`，避免 GitHub↔CNB 相互推送造成死循环。

---

## 路径过滤设计

三个 workflow 的 paths 各自维护（GitHub Actions 不支持跨文件复用）：

| 路径 | quality.yml | build.yml | sync-cnb.yml |
|------|:---:|:---:|:---:|
| `src/**` `modules/**` `*.cls` `*.sty` `*.dtx` `*.ins` `*.tex` | ✅ | ✅ | ✅ |
| `testfiles/**` `tests/**` `.chktexrc` | ✅ | ❌ | ✅ |
| `justfile` | ✅ | ✅ | ✅ |
| `.github/tl_packages*` | ✅ | ✅（仅 `tl_packages`） | ❌（被 `.github/**` 排除） |
| workflow 自身文件 | ✅ | ✅ | ❌ |
| `README.md` | ❌ | ❌ | ✅ |
| `CHANGELOG.md` | ❌ | ❌ | ❌（防连锁） |

**设计意图**：
- `quality.yml` 是**最全**的一份（含测试与 lint 配置）
- `build.yml` **有意不含**测试路径（测试改动不影响构建产物）
- `sync-cnb.yml` 与 `quality.yml` 对齐（改 GitHub 后回灌 CNB 保持测试同步）

---

## concurrency 与缓存

- **concurrency**：每个 workflow 设置 `cancel-in-progress: true`，连续 push 自动取消旧运行
- **TeX Live 缓存**：`zauguin/install-texlive@v4` 默认自动缓存 `~/texlive`，跨 workflow 复用；改包列表 `tl_packages` / `tl_packages_lint` 会自然导致缓存失效重建
