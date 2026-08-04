# SDUThesis 优化计划

> 参考成熟项目：thuthesis（l3build 回归测试、100+ 配置键）、BIThesis（模块化、文档体系）
> 状态：规划中，逐 Phase 实施

---

## 现状诊断

### 做得好的
- 插件化架构（内核 + 模块 + Hook）已成型
- SDUSetup 集中配置，DTX 代码文档合一
- CI/CD 完整（编译、测试、发布、字体链接）
- 文档齐全（用户手册、开发者文档、排障记录）

### 核心短板

| 短板 | 现状 | 成熟项目做法 |
|------|------|--------------|
| 回归测试 | 自定义 Python 脚本，只查编译是否成功 | **l3build** + `testfiles/`（.tex + .tlg 配对），逐模块输出对比 |
| 配置覆盖度 | 只支持 10 个键 | `\thusetup{}` 支持 100+ 键，分 cover/info/style/misc 四组 |
| 封面实现 | 硬编码在 undergraduate 模块 | 封面、承诺书、声明等每个页面单独测试文件 |
| 字体方案 | Fandol（依赖环境） | 多字体集可选（fandol/windows/mac/ubuntu）+ 系统检测 |
| 用户模板 | 单个 main.tex | 完整示例 + data/ + ref/ 分离 |
| CTAN 元数据 | 无 | README + CHANGELOG + license + 完整 TDS |

---

## Phase 1：回归测试升级（最高优先）

**目标**：从"能编译"升级到"输出正确"。

**做法（参考 thuthesis）**：
1. 引入 `l3build`（TeX Live 自带）
2. 创建 `testfiles/` 目录，每个关键功能一个测试：
   - `01-cover.tex/.tlg` — 封面输出
   - `02-abstract.tex/.tlg` — 摘要
   - `03-contents.tex/.tlg` — 目录
   - `04-bib.tex/.tlg` — 参考文献
   - `05-blindreview.tex/.tlg` — 盲审模式
3. 每个测试编译后与期望 `.tlg` diff，任何非预期变化都会导致 CI 失败
4. 保留现有 test-compile.py 作为基础编译检查

**交付物**：
- `build.lua`（l3build 配置）
- `testfiles/` 目录（5 个测试）
- CI 增加 l3build test 步骤

---

## Phase 2：SDUSetup 配置体系扩展

**目标**：从 10 个键扩展到 40+ 键，分组管理（参考 thuthesis）。

**分组设计**：
```
\SDUSetup{
  info = {          % 论文信息
    title, titleEn, author, studentId, school, major,
    supervisor, year, month, abstractCn, abstractEn, keywordsCn, keywordsEn
  },
  style = {         % 样式
    fontset,        % 字体集：fandol / windows / mac / ubuntu / none
    lineSpread,     % 行距
    fontSize,       % 正文字号
    pageMargins,    % 页边距
    tocDepth,       % 目录深度
    bibStyle,       % 参考文献样式
  },
  module = {        % 模块
    undergraduate / master / doctor / blindreview
  },
  misc = {          % 其他
    logo, draft, showComments
  }
}
```

**关键新增键**：
- `titleEn / abstractEn / keywordsEn` — 英文封面和摘要支持
- `fontset` — 字体自动检测（Windows 用宋体，Mac 用苹方，Linux 用 Fandol）
- `draft` — 草稿模式（加水印、单面打印、时间戳）
- `showComments` — 显示批注（导师批注功能）

**注意**：分组设计是**向后不兼容**的重大变更（当前是扁平键），需要同步更新用户手册和示例。

---

## Phase 3：代码质量重构

**目标**：消除 DTX 中的实现细节问题。

**具体项**：
1. **`\sdu_load_module:` 逻辑清理** — 当前用 `\input@path` hack 处理 Overleaf，模块加载耦合在 cls 中。改为模块通过 Hook 注册，内核只负责转发。
2. **魔法数字消除** — 封面排版里的 `\vspace{2cm}`、`\hspace{3em}` 等硬编码间距，提取为 SDUSetup 键。
3. **`\ExplSyntaxOn` 区域规范** — 确保所有 LaTeX3 函数定义集中，避免混合。
4. **错误提示增强** — 模块加载失败时给出中文友好提示（thuthesis 的做法：`\ClassError` 带详细说明）。

---

## Phase 4：发布生态

**目标**：进入 TeX Live + Overleaf 模板库。

**具体项**：
1. **CTAN 提交包整理** — 现有 `scripts/ctan-pack.sh` 已生成 TDS，补充 README.CTF
2. **Overleaf Gallery 提交** — 整理一个干净的模板 zip（不含测试/CI/文档源码）
3. **英文 README** — 吸引国际用户
4. **CHANGELOG 自动发布** — 已用 git-cliff，补充 release 说明模板

---

## 执行顺序

```
Phase 1 (l3build 回归测试)  ← 安全网，先做
    ↓
Phase 2 (SDUSetup 扩展)    ← 功能增强，用户可见
    ↓
Phase 3 (代码质量重构)      ← 在测试保护下重构，安全
    ↓
Phase 4 (发布生态)          ← 收尾
```

每个 Phase 独立成 PR，走 develop → main 流程。
