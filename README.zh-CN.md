# skill-scaffold

[English](./README.md) | [简体中文](./README.zh-CN.md)

`skill-scaffold` 是一套面向本地 AI Skills 的最佳实践管理系统，适用于 Skills 安装和使用数量持续增长之后的场景。

它帮助用户在创建、安装、审查、组织、索引和校验 Skills 时采用统一方法，让 Skills 更容易查找、更容易正确触发，也更容易长期维护。

---

## 背景

当你只有少量本地 Skills 时，轻量管理通常已经够用。

你可以靠记忆记住它们：

```text
code-review
prd-review
concept-explain
```

但一旦 Skill 开始被频繁安装和持续使用，数量通常会很快增长：

```text
learn-concept-explain
pm-prd-review
pm-feature-design
ux-prototype-review
code-safe-feature
code-bug-fix
code-review
db-migration-review
ops-release-check
doc-architecture-update
...
```

这时真正的问题就不再是“有没有这个 Skill”，而是：

- 当前任务到底该用哪个 Skill
- AI 应该在什么场景下触发哪个 Skill
- 如何避免模糊命名和模糊 description
- 如何避免高风险 Skill 被误触发
- 如何区分 global Skill 和 project Skill
- 如何在 Skill 越来越多后仍然保持库可理解、可维护
- 如何让 Claude Code、Codex、VSCode AI IDE 按同一套规则工作

这个仓库就是为这个阶段准备的。

---

## 为什么需要它

大多数用户真正缺的，不是“再多几个 Skill”，而是“管理现有和将来安装的 Skills 的方法”。

如果没有一套统一规范，本地 Skills 很容易逐渐变成一堆难以维护的目录和提示词：

```text
helper
review
fix
agent
workflow
my-skill
```

这通常会带来：

- 不好找
- 职责重叠
- 触发不准
- 风险不可控
- 结构不统一
- 团队之间难以共享

`skill-scaffold` 要解决的，就是这个管理问题。

---

## skill-scaffold 是什么

`skill-scaffold` 不只是一个安装器。

它更像是一个围绕本地 AI Skills 的管理脚手架和最佳实践工作流。

它帮助用户从 Skill 创建或安装的那一刻开始，就按统一规范管理 Skills，而不是等 Skill 库变乱之后再返工整理。

它具体包含：

- 一个管理 Skill：[skills/skill-scaffold/SKILL.md](</C:/00.work/04.code/skill-scaffold/skills/skill-scaffold/SKILL.md>)
- 一份 Skill 规范：[docs/SKILL_SPEC.md](</C:/00.work/04.code/skill-scaffold/docs/SKILL_SPEC.md>)
- 一份索引规范：[docs/SKILLS_INDEX_SPEC.md](</C:/00.work/04.code/skill-scaffold/docs/SKILLS_INDEX_SPEC.md>)
- 安装、生成索引、校验脚本
- 示例 Skills 和多工具使用文档

---

## 我能做什么

`skill-scaffold` 在 Skill 创建阶段和安装阶段都能提供帮助。

### 创建 Skill 时

它可以帮助你：

- 选择清晰的 Skill 名称
- 编写面向触发的 description
- 决定 Skill 应该是 global 还是 project 级
- 给 Skill 设定合理的风险等级
- 决定是否禁用自动调用
- 生成标准目录结构
- 保持 `SKILL.md` 简洁，把细节移动到 supporting files

### 安装 Skill 时

它可以帮助你：

- 在信任第三方 Skill 之前先审查
- 把 Skill 安装到正确的位置
- 必要时规范化命名和结构
- 生成或更新 `SKILLS_INDEX.md`
- 安装完成后进行校验

### 管理越来越多的 Skill 时

它可以帮助你：

- 保持命名扁平且可检索
- 减少 Skills 之间的重叠
- 让高风险 Skills 保持手动调用
- 维持一致的目录结构
- 维护一个人和 AI 都能快速使用的索引

---

## 我不做什么

`skill-scaffold` 不会默认自动接管你所有现有 Skills。

默认情况下，它不会：

- 静默重构整套 Skill 库
- 盲目信任 GitHub 第三方仓库
- 执行远程安装脚本
- 跳过第三方高风险 Skill 的审查
- 自动执行高风险脚本

它是管理层和规范层，不是盲目的自动化层。

---

## 最终交付什么价值

`skill-scaffold` 的价值不只是“能创建一个 Skill”或者“能安装一个 Skill”。

它真正交付的，是一套可以让 Skill 体系随着数量增长仍然可用的管理方式。

具体价值包括：

- Skills 更容易被找到
- Skills 更容易被正确触发
- 高风险 Skills 更安全
- 新 Skill 从一开始就有更好的默认结构
- 团队协作时更一致
- 大量 Skill 不会逐渐退化成难以维护的 prompt 堆

可以把它理解成：

> 当你只有几个 Skills 时，靠记忆可能就够了。  
> 当你有很多 Skills 时，你需要的是一套系统。  
> `skill-scaffold` 就是这套系统的起点。

---

## 适合谁

这个仓库尤其适合：

- 本地已经安装了很多 Skills 的个人用户
- 在项目中沉淀 AI 工作流的开发者
- 经常安装新 Skill 的产品经理或 AI 重度用户
- 想统一 Skill 标准的团队
- 想更安全地从 GitHub 安装 Skill 的用户

---

## 当前能力

当前仓库包含：

- 一个管理 Skill：[skills/skill-scaffold/SKILL.md](</C:/00.work/04.code/skill-scaffold/skills/skill-scaffold/SKILL.md>)
- 核心 Skill 规范：[docs/SKILL_SPEC.md](</C:/00.work/04.code/skill-scaffold/docs/SKILL_SPEC.md>)
- 索引规范：[docs/SKILLS_INDEX_SPEC.md](</C:/00.work/04.code/skill-scaffold/docs/SKILLS_INDEX_SPEC.md>)
- 安装文档：[docs/INSTALLATION.md](</C:/00.work/04.code/skill-scaffold/docs/INSTALLATION.md>)
- Claude Code 文档：[docs/USAGE_WITH_CLAUDE_CODE.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_CLAUDE_CODE.md>)
- Codex 文档：[docs/USAGE_WITH_CODEX.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_CODEX.md>)
- VSCode AI IDE 文档：[docs/USAGE_WITH_VSCODE_AI_IDE.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_VSCODE_AI_IDE.md>)
- 第三方 Skill 审查清单：[docs/THIRD_PARTY_SKILL_REVIEW.md](</C:/00.work/04.code/skill-scaffold/docs/THIRD_PARTY_SKILL_REVIEW.md>)
- `SKILLS_INDEX` 模板：[docs/SKILLS_INDEX_TEMPLATE.md](</C:/00.work/04.code/skill-scaffold/docs/SKILLS_INDEX_TEMPLATE.md>)
- bash 和 PowerShell 的安装脚本
- bash 和 PowerShell 的校验脚本
- bash 和 PowerShell 的 `SKILLS_INDEX.md` 生成脚本
- 位于 [examples](</C:/00.work/04.code/skill-scaffold/examples>) 下的示例 Skills

---

## 仓库结构

```text
skill-scaffold/
|- AGENTS.md
|- README.md
|- README.zh-CN.md
|- docs/
|  |- INSTALLATION.md
|  |- SKILL_SPEC.md
|  |- SKILLS_INDEX_SPEC.md
|  |- SKILLS_INDEX_TEMPLATE.md
|  |- THIRD_PARTY_SKILL_REVIEW.md
|  |- USAGE_WITH_CLAUDE_CODE.md
|  |- USAGE_WITH_CODEX.md
|  `- USAGE_WITH_VSCODE_AI_IDE.md
|- scripts/
|  |- generate-skills-index.ps1
|  |- generate-skills-index.sh
|  |- install-skill.ps1
|  |- install-skill.sh
|  |- validate-skill.ps1
|  `- validate-skill.sh
|- skills/
|  `- skill-scaffold/
|     |- SKILL.md
|     |- examples/
|     |- references/
|     `- templates/
`- examples/
   |- code-safe-feature/
   |- learn-concept-explain/
   `- pm-prd-review/
```

---

## 推荐工作流

对于新 Skill，推荐：

1. 阅读 `AGENTS.md`、`docs/SKILL_SPEC.md` 和 `docs/SKILLS_INDEX_SPEC.md`
2. 先要求输出 plan，再创建文件
3. 确认最终名称、作用域、风险等级和索引影响
4. 创建 Skill 文件
5. 生成或更新 `SKILLS_INDEX.md`
6. 运行校验
7. 在真实任务中测试

对于第三方 Skill，推荐：

1. 先把来源 clone 或复制到临时审查位置
2. 检查 `SKILL.md`、`references/`、`templates/`、`examples/` 和 `scripts/`
3. 使用 [docs/THIRD_PARTY_SKILL_REVIEW.md](</C:/00.work/04.code/skill-scaffold/docs/THIRD_PARTY_SKILL_REVIEW.md>) 做审查
4. 决定应放入 `global`、`project`、`lab`、`disabled` 还是 `archive`
5. 审查通过后再安装
6. 生成或更新 `SKILLS_INDEX.md`
7. 最后做校验

---

## 跨工具使用

这个仓库支持三种主要使用方式：

- Claude Code：手动 `/skill-scaffold` 工作流
- Codex：基于 `AGENTS.md` 和规范文档的文件驱动工作流
- VSCode AI IDE：基于项目规则和提示词的工作流

可以从这些文档开始：

- [docs/USAGE_WITH_CLAUDE_CODE.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_CLAUDE_CODE.md>)
- [docs/USAGE_WITH_CODEX.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_CODEX.md>)
- [docs/USAGE_WITH_VSCODE_AI_IDE.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_VSCODE_AI_IDE.md>)

---

## 安全默认值

这个仓库默认遵循：

- 不执行远程安装脚本
- 不使用 `curl | bash`
- 不默认部署
- 不默认执行数据库变更
- 不在未获明确授权时读取 `.env` 或 SSH keys
- 不在未确认前做破坏性文件操作
- 不把未经审查的第三方脚本直接放进 active Skill 目录

如果有不确定的地方，优先选择手动调用、更小范围和显式审查。

---

## 总结

`skill-scaffold` 面向的是这样一个阶段：本地 AI Skills 已经不再是少量个人收藏，而开始变成一个持续增长的系统。

它帮助用户从一开始就用最佳实践去创建和安装 Skills，让 Skills 更容易使用、更容易扩展，也更容易长期维护。

## 社区

 [LINUX DO — 中文开发者社区](https://linux.do/) 
