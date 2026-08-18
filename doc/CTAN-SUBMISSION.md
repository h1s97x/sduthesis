# SDUThesis CTAN 提交清单

> 提交地址：https://ctan.org/upload
> 包名：`sduthesis`（CTAN 与 TeX Live 中当前无冲突）

## 提交材料（由 `scripts/build-ctan.sh` 生成）

`sduthesis-ctan.zip` 包含：

| 文件 | 说明 |
|---|---|
| `sduthesis.dtx` | 内核源码 + 文档（docstrip 格式） |
| `sduthesis.ins` | 安装脚本 |
| `sduthesis-undergraduate.sty` / `sduthesis-master.sty` / `sduthesis-blindreview.sty` | 可选模块 |
| `README` | **纯文本**说明（CTAN 要求无扩展名） |
| `README.md` | Markdown 版（在线浏览用） |
| `LICENSE` | LPPL-1.3c |
| `sduthesis-doc.pdf` | 用户/开发者文档 |
| `sduthesis.tds.zip` | TDS 规范包（TeX Live 安装用） |

## 提交表单填写

| 字段 | 值 |
|---|---|
| Package name | `sduthesis` |
| Version | `2.1.1` |
| License | `lppl1.3c` |
| Author | h1s97x <Yang1297656998@outlook.com> |
| Summary | LaTeX template for Shandong University theses (bachelor/master/doctoral), kernel + module architecture |
| Repository | https://github.com/h1s97x/sduthesis |
| CTAN location | macros/latex/contrib/sduthesis |
| Topics | thesis, chinese, ctex, xelatex, biblatex |
| File | `sduthesis-ctan.zip`（用 ctan 表单直接上传） |

## 上传前自检（已自动化）

1. `xelatex sduthesis.ins` 生成 `sduthesis.cls` 无报错
2. `xelatex sduthesis.dtx` ×2 生成 `sduthesis-doc.pdf` 无报错
3. `latexmk -xelatex main.tex` 完整编译示例论文（28 页）
4. `chktex -q sduthesis.cls modules/*.sty sdusetup.tex` 零 warning
5. `sduthesis.tds.zip` 符合 TDS（tex/doc/source 三层结构）

## 收录后的收益

- TeX Live 自带：用户 `\documentclass{sduthesis}` 即可用，无需手动装
- Overleaf 模板库可引用 CTAN 包，进一步降低使用门槛
- 符合 LaTeX 社区规范（LPPL-1.3c + TDS + CTAN 三位一体）

## 注意

- CTAN 审核周期通常数天到数周，期间若发现问题会邮件反馈
- 上传后如需更新，直接再次上传新版本 zip（CTAN 会保留历史版本）
- 提交前确认 `README` 为纯文本（无 Markdown 标记），已由脚本保证
