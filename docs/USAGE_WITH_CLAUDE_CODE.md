# Usage with Claude Code

This guide explains how to use `skill-scaffold` with Claude Code.

---

## 1. Recommended setup

Install `skill-scaffold` globally:

```bash
mkdir -p ~/.claude/skills
cp -R skills/skill-scaffold ~/.claude/skills/
```

Then use project-level Skills inside each repository:

```text
your-project/
├── AGENTS.md
├── CLAUDE.md
├── docs/
│   └── AI_CODEMAP.md
└── .claude/
    ├── SKILLS_INDEX.md
    └── skills/
        ├── code-safe-feature/
        ├── code-bug-fix/
        ├── db-migration-review/
        └── ops-release-check/
```

---

## 2. Why global install is recommended

`skill-scaffold` is a meta Skill.

It helps create other Skills.

It is not tied to a single codebase, so global installation is usually best:

```text
~/.claude/skills/skill-scaffold/
```

Project-specific Skills should live in the project:

```text
.claude/skills/<skill-name>/
```

---

## 3. Manual invocation

`skill-scaffold` should normally be manually invoked because it creates or modifies files.

Use:

```text
/skill-scaffold
```

Example:

```text
/skill-scaffold

我要创建一个项目级 Skill：
- domain: code
- name: safe-feature
- risk: high
- purpose: 新增功能前做安全变更分析

先不要创建文件，先输出创建方案。
```

Expected response:

1. Final Skill name
2. Scope
3. Target directory
4. Domain
5. Risk level
6. Whether auto invocation should be disabled
7. Files to create
8. Whether scripts are needed
9. Validation checklist

---

## 4. Two-step creation flow

Use a two-step flow for safety.

### Step 1: Plan

```text
/skill-scaffold

我要创建一个项目级 Skill：
- domain: pm
- name: prd-review
- risk: medium
- purpose: 评审产品需求文档，检查目标、用户场景、业务流程、边界条件、验收标准和实现风险

先不要创建文件，先输出创建方案。
```

### Step 2: Create

```text
确认，请按方案创建文件，并更新 .claude/SKILLS_INDEX.md。
```

This prevents accidental file creation or unsafe behavior.

---

## 5. Recommended project instructions

Add this to `AGENTS.md` or `CLAUDE.md` in your project:

```md
## Skill creation rules

When the user asks to create, install, update, organize, or validate a Skill:

1. Use `/skill-scaffold` if available.
2. Read `docs/SKILL_SPEC.md` if it exists.
3. Do not create files immediately.
4. First output:
   - Skill name
   - Scope
   - Domain
   - Risk level
   - Target directory
   - Files to create
   - Whether auto invocation should be disabled
5. Wait for confirmation unless the user explicitly says to proceed directly.
6. Create the Skill under `.claude/skills/<skill-name>/`.
7. Update `.claude/SKILLS_INDEX.md`.
8. Do not create scripts unless required.
9. Do not add scripts with risky commands without explicit approval.
```

---

## 6. Creating a code Skill

Example prompt:

```text
/skill-scaffold

我要创建一个项目级 Skill：
- domain: code
- name: safe-feature
- risk: high
- purpose: 新增功能前做安全变更分析。先读取 AGENTS.md 和 docs/AI_CODEMAP.md，判断目标模块、影响文件、风险等级和回归测试清单。

要求：
1. 高风险，必须手动调用
2. 不要创建危险脚本
3. 生成 references、templates、examples
4. 更新 .claude/SKILLS_INDEX.md

先输出创建方案。
```

Recommended final name:

```text
code-safe-feature
```

Recommended frontmatter:

```yaml
---
name: code-safe-feature
description: Analyze a requested feature change before editing code. Use when adding or modifying features, APIs, pages, database fields, or workflows. Do not use for simple copywriting or one-line style changes. Keywords: new feature, API change, workflow change, before coding.
disable-model-invocation: true
---
```

---

## 7. Creating a PRD review Skill

Example prompt:

```text
/skill-scaffold

我要创建一个项目级 Skill：
- domain: pm
- name: prd-review
- risk: medium
- purpose: 评审产品需求文档，检查目标、用户场景、业务流程、边界条件、验收标准和实现风险。

先输出创建方案，不要创建文件。
```

Recommended final name:

```text
pm-prd-review
```

---

## 8. Creating a learning Skill

Example prompt:

```text
/skill-scaffold

我要创建一个全局 Skill：
- domain: learn
- name: concept-explain
- risk: low
- purpose: 用结构化方式解释 AI、产品和技术概念，包括是什么、为什么重要、如何工作、实际例子和常见误区。

先输出创建方案。
```

Recommended final name:

```text
learn-concept-explain
```

Recommended target:

```text
~/.claude/skills/learn-concept-explain/
```

---

## 9. Updating SKILLS_INDEX.md

Prompt:

```text
/skill-scaffold

请检查当前项目 .claude/skills 下的 Skills，并更新 .claude/SKILLS_INDEX.md。

要求包含：
- Skill
- Domain
- Scope
- Risk
- Auto trigger
- Purpose
```

Recommended index format:

```md
| Skill | Domain | Scope | Risk | Auto trigger | Purpose |
|---|---|---|---|---|---|
| code-safe-feature | code | project | high | No | Analyze feature changes before editing code |
| pm-prd-review | pm | project | medium | Yes | Review product requirement documents |
```

---

## 10. Validation prompt

Use:

```text
/skill-scaffold

请校验当前项目 .claude/skills 下所有 Skills 是否符合最佳实践。

重点检查：
1. 命名是否 kebab-case
2. description 是否具体
3. 高风险 Skill 是否有 disable-model-invocation: true
4. 是否有 Purpose / Best for / Not for / Required inputs / Workflow / Output format / Safety rules
5. scripts 是否存在危险命令
6. SKILLS_INDEX.md 是否更新
```

---

## 11. Common mistakes

### Mistake 1: Skill name is too vague

Bad:

```text
review
helper
fix
```

Good:

```text
pm-prd-review
code-bug-fix
db-migration-review
```

### Mistake 2: Description is too broad

Bad:

```yaml
description: Helps with product work.
```

Good:

```yaml
description: Review product requirement documents. Use when checking goals, user scenarios, workflows, edge cases, acceptance criteria, and implementation risks. Do not use for coding or deployment tasks. Keywords: PRD, product requirement, feature review, acceptance criteria.
```

### Mistake 3: High-risk Skill allows automatic invocation

For code, database, or ops Skills, prefer:

```yaml
disable-model-invocation: true
```

### Mistake 4: Too much content in SKILL.md

Move details into:

```text
references/
templates/
examples/
```

---

## 12. Recommended workflow summary

Use this flow:

```text
Install skill-scaffold globally
↓
Open Claude Code in your project
↓
Run /skill-scaffold
↓
Ask for a creation plan
↓
Confirm file creation
↓
Review generated Skill
↓
Update SKILLS_INDEX.md
↓
Validate
↓
Use the new Skill manually or automatically based on risk
```
