# 更新日志

本文档记录 SDUThesis 模板的所有重要变更。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

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
