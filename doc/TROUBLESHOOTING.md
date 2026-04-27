# CI 构建问题修复记录

## 问题汇总

本项目在 CI 构建过程中遇到以下问题，已全部修复。

---

## 问题 1：xelatex 参数错误

**错误信息**：
```
xelatex: unrecognized option `-pdf'
```

**原因**：`xelatex` 不支持 `-pdf` 参数

**修复方案**：移除 `-pdf` 参数

**涉及文件**：
- `.github/workflows/build.yml`

---

## 问题 2：字体缺失

**错误信息**：
```
Package fontspec Error: The font "Times New Roman" cannot be found
```

**原因**：Docker 镜像中没有 Windows/macOS 专有字体

**修复方案**：添加字体存在性检测，优先使用本地字体，不存在时使用开源字体

**涉及文件**：
- `config/main/config-main.tex`

---

## 问题 3：citing 命令未定义

**错误信息**：
```
! Undefined control sequence.
l.7 ...断系统能够帮助医生... \citing{esteva2017dermatologist}
```

**原因**：模板未定义 `\citing` 命令

**修复方案**：添加 `\let\citing\parencite`

**涉及文件**：
- `config/main/config-main.tex`

---

## 问题 4：图片文件缺失

**错误信息**：
```
! Unable to load picture or PDF file 'convolution.png'.
```

**原因**：示例论文引用了不存在的图片

**修复方案**：
1. 创建 `assets/figures/` 目录及占位图片
2. 修正图片引用路径为 `assets/figures/xxx.png`

**涉及文件**：
- `data/chapters/chapter2.tex`
- `data/chapters/chapter3.tex`
- `data/chapters/chapter4.tex`
- `data/frontmatter/appendix.tex`
- `assets/figures/` (新增目录)

---

## 问题 5：伪代码命令冲突

**错误信息**：
```
! Undefined control sequence.
l.62 \REQUIRE 输入特征图...
```

**原因**：同时加载了 `algorithmicx` 和 `algorithm2e`，命令不兼容

**修复方案**：
1. 只保留 `algorithm2e`
2. 统一伪代码环境为 `algorithm2e`
3. 将 `\STATE` 改为 `\State`，`\REQUIRE` 改为 `\KwIn`

**涉及文件**：
- `config/main/config-main.tex`
- `data/chapters/chapter3.tex`

---

## 修复提交历史

| 提交 | 描述 |
|------|------|
| `4317523` | 修复 CI 构建、示例论文和跨平台兼容性 |
| `18773ee` | 修复 algorithm2e 伪代码命令兼容性 |
| `a4b3127` | 统一伪代码环境为 algorithm2e |

---

## 验证方法

```bash
# 本地验证
xelatex main.tex
biber main
xelatex main.tex
xelatex main.tex
```

或提交代码触发 GitHub Actions 自动构建。

---

## 问题 6：伪代码宏包冲突

**错误信息**：
```
! LaTeX Error: Environment algorithm2e undefined.
```

**原因**：`config-main.tex` 同时加载了 `algorithm2e` 和 `algpseudocode`（algorithmicx），两个宏包冲突

**修复方案**：移除 `algpseudocode`，只保留 `algorithm2e`

**涉及文件**：
- `config/main/config-main.tex`
