# 开发指南

> [返回首页](./README.md) | [上一节：CI/CD 流水线](./ci-cd.md) | [下一节：设计决策](./design-decisions.md)

---

## 开发流程

参考 [ROADMAP.md](file:///workspace/doc/ROADMAP.md) 的 Git 工作流：

```
1. 从 develop 切特性分支
   git checkout -b feat/your-feature develop

2. 开发 + 本地测试
   just gen       # 修改 DTX 后重新生成 cls
   just build     # 确保能编译
   just lint      # chktex 检查（与 CI 一致）
   just test      # 运行编译测试

3. 推送并创建 PR → develop
   git push origin feat/your-feature

4. CI 自动检查（quality.yml: lint + 回归）
5. Code review
6. 合并到 develop
7. 发版时 develop → main，打 tag 触发 release
```

---

## 分支命名规范

| 类型 | 格式 | 示例 |
|------|------|------|
| 功能 | `feat/<描述>` | `feat/hook-system` |
| 修复 | `fix/<描述>` | `fix/coverpage-alignment` |
| 文档 | `docs/<描述>` | `docs/user-manual` |
| 重构 | `refactor/<描述>` | `refactor/plugin-arch` |
| 发布 | `release/v<版本>` | `release/v1.2.0` |
| 热修 | `hotfix/v<版本>` | `hotfix/v1.1.1` |

---

## 提交信息规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/)：

```
<type>(<scope>): <subject>

<body>

<footer>
```

| type | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | 修复 |
| `docs` | 文档 |
| `refactor` | 重构（不改变外部行为） |
| `test` | 测试 |
| `ci` | CI/CD |
| `chore` | 构建/工具 |

---

## 如何添加新的 SDUSetup 键

以添加 `abstractCn` 键为例，四步流程（详见 [doc/DEVELOP.md](file:///workspace/doc/DEVELOP.md)）：

**第 1 步：声明变量（存储层）** —— 在 [src/sduthesis.dtx](file:///workspace/src/sduthesis.dtx) 的 `\ExplSyntaxOn` 区域：

```latex
\tl_new:N \l__sdu_abstract_cn_tl    % 命名规范：\l__sdu_<键名>_tl
```

**第 2 步：注册键（定义层）** —— 论文信息类键注册到 `sdu/info` 组，样式类键注册到 `sdu/option` 组；如需平铺兼容，再在 `sdu` 组加同名别名：

```latex
\keys_define:nn { sdu / info } {
  abstractCn   .tl_set:N = \l__sdu_abstract_cn_tl,
  abstractCn   .initial:n = { },    % 可选：默认值
}
```

**第 3 步：导出 Getter（导出层）**：

```latex
\NewDocumentCommand \GetAbstractCn { } { \l__sdu_abstract_cn_tl }
```

**第 4 步：在模块中使用** —— 模块通过 Getter 获取值：

```latex
\renewenvironment{cnabstract}{ \GetAbstractCn }{}
```

> 完成后运行 `just gen` 重新生成 `sduthesis.cls`。

---

## 如何创建新模块

参考 [doc/DEVELOP.md](file:///workspace/doc/DEVELOP.md) 与现有模块：

1. 创建 `modules/sduthesis-<name>.sty`
2. 用 `\renewcommand` / `\renewenvironment` 覆盖封面和环境（**不是** `\newcommand`，因为内核已定义空实现）
3. 用 `\AddToHook` 在文档阶段注入页眉页脚和章节格式
4. 用 `\keys_define:nn { sdu }` 注册模块特有的配置键（如需）
5. 用户通过 `\SDUSetup{module=<name>}` 加载

模块模板：

```latex
\ProvidesPackage{sduthesis-<name>}[YYYY/MM/DD vX.Y.Z SDUThesis <name> module]

% 1. 覆盖封面
\renewcommand{\makecoverpage}{ ... }

% 2. 覆盖摘要环境
\renewenvironment{cnabstract}{ ... }{ ... }

% 3. 通过 Hook 注入页眉页脚
\AddToHook{sduthesis/mainmatter/begin}{
  \fancypagestyle{plain}{ ... }
  \pagestyle{plain}
}

\endinput
```

---

## LaTeX3 命名规范

| 类型 | 格式 | 示例 |
|------|------|------|
| 内部变量 | `\l__sdu_<name>_<type>` | `\l__sdu_title_tl` |
| 内部函数 | `\sdu_<name>:` | `\sdu_load_module:` |
| 用户命令 | `\CamelCase` | `\SDUSetup`、`\GetTitle` |
| 变量类型后缀 | `_tl`（token list）/ `_dim`（dimension）/ `_seq`（序列）/ `_bool`（布尔） | — |

---

## 关键约束

1. **LaTeX3 函数必须在 `\ExplSyntaxOn` 区域内调用**，包括 `\AddToHook` 中的回调
2. **`\renewcommand` 而非 `\newcommand`** —— 内核已定义空实现，模块覆盖
3. **模块加载时序** —— 模块在 `\begin{document}` 时加载（通过 `\AddToHook{begindocument}`），早于 `main.tex` 中的任何排版命令
4. **修改 DTX 后必须 `just gen`** —— 不要手动编辑 `sduthesis.cls`
5. **新增 lint 排除规则前** —— 必须本地跑 `chktex -q sduthesis.cls modules/*.sty sdusetup.tex` 验证零 warning
6. **新增测试必须提交 `.tlg` 基线** —— 否则 push 到 develop 会硬失败
7. **附录必须在 `\backmatter` 之前** —— `\appendix` 依赖 `\@mainmattertrue` 才能生成"附录A/B/C"编号（历史 bug PR #12）

---

## VS Code 集成

[.vscode/tasks.json](file:///workspace/.vscode/tasks.json) 提供常用构建任务：

- 编译论文（xelatex）
- 编译参考文献（biber）
- 完整编译（推荐）：`xelatex main.tex && biber main && xelatex main.tex && xelatex main.tex`
- 使用 latexmk 编译
- 清理临时文件
- 查看 PDF（依赖 LaTeX Workshop 扩展）
