# 更新日志

本文档记录 SDUThesis 模板的所有重要变更。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### Added

- **添加完整示例论文**：包含封面、摘要、5个章节、参考文献、致谢、附录的完整示例
  - 主题：基于深度学习的图像识别算法研究
  - 涵盖图表、公式、算法、代码等多种示例
- **完善 FAQ 文档**：新增 20+ 常见问题解答，涵盖编译、字体、格式、Overleaf 使用等
- **添加 VSCode 配置**：完整的 LaTeX Workshop 配置，包括编译工具链和任务
- **创建 GitHub Actions 工作流**：自动编译、PDF 生成、构建日志上传
- **添加云端部署指南**：Overleaf 和 TeXPage 部署教程
- **添加 CONTRIBUTING.md**：贡献指南，说明项目起源和致谢
- **添加 DEPLOYMENT.md**：云端部署完整指南
- **添加 sdusetup.tex 用户配置文件**：集中管理论文信息
- 添加 config/styles/ 目录，重构样式文件结构
- 添加 config/user/ 目录，提供备用配置方式
- 添加 docs/MIGRATION.md 配置迁移指南
- 改进 abstract.tex，参考 thuthesis 提供更详细的示例

### Changed

- 重命名 src/ 目录为 data/，符合学术论文模板标准
- 适配 chapter2-5 内容，移除 thuthesis 特有命令
- 优化配置文件结构，将样式文件移至 config/styles/
- 更新 main.tex 使用新的目录结构
- 修复字体路径（fonts/ -> assets/fonts/）
- 修复章节文件名引用
- 更新 README.md 反映新的项目结构

### Removed

- 删除 update/ 目录（已迁移到 config/styles/）

### Deprecated

- update/ 目录已删除，请使用 config/styles/

## [1.1.0] - 2025-02-27

### Added

- 添加 Makefile 构建工具，支持 `make`、`make clean`、`make cleanall` 等命令
- 添加 build.bat Windows 构建脚本
- 添加 latexmkrc 配置文件，实现自动化编译和依赖管理
- 添加 CHANGELOG.md 版本更新记录
- 添加 FAQ.md 常见问题解答文档（20+ 个问题）
- 添加 docs/examples/ 使用示例目录（图片、表格、公式）
- 添加 GitHub Actions 自动构建工作流（.github/workflows/build.yml）
- 添加 GitHub Actions 自动发布工作流（.github/workflows/release.yml）
- 添加 GitHub Actions 自动更新 CHANGELOG 工作流（.github/workflows/changelog.yml）

### Changed

- 优化项目结构，将资源文件统一到 assets/ 目录
- 改进 .gitignore 规则，精确控制文件跟踪
- 更新 README.md，添加快速开始指南和构建工具说明

### Fixed

- 修复编译过程中的路径引用问题
- 修复字体加载警告

## [1.0.0] - 2024-12-30

### Added
- 初始版本发布
- 基于《山东大学本科毕业论文（设计）撰写规范》（2024版）
- 支持 XeLaTeX 编译
- 支持 GB/T 7714-2015 参考文献格式
- 提供完整的论文示例

### Features
- 自动配置符合规范的页面设置、字体和段距
- 图表插入与自动编号功能
- 数学公式支持（unicode-math）
- 参考文献管理（biblatex）
- 封面、摘要、目录、正文和附录自动生成

---

## 版本说明

### 版本号格式
- **主版本号**: 不兼容的 API 修改
- **次版本号**: 向下兼容的功能性新增
- **修订号**: 向下兼容的问题修正

### 变更类型
- **Added**: 新增功能
- **Changed**: 功能变更
- **Deprecated**: 即将废弃的功能
- **Removed**: 已移除的功能
- **Fixed**: 问题修复
- **Security**: 安全性修复

---
