# Trigger Examples

This file helps define when the `skill-scaffold` Skill should and should not be used.

The purpose of `skill-scaffold` is to create, install, standardize, organize, or validate local AI Skills.

It should not be used for normal product, coding, learning, writing, or deployment tasks.

---

## Should use this Skill

Use `skill-scaffold` when the user asks to create a new Skill.

### Example 1

```text
帮我创建一个用于 PRD 评审的 Skill。
```

Expected behavior:

* Identify domain: `pm`
* Suggest name: `pm-prd-review`
* Determine scope: project or global
* Determine risk: medium
* Generate `SKILL.md`
* Create supporting directories
* Update `SKILLS_INDEX.md`

---

### Example 2

```text
我要做一个 code-safe-feature Skill，用于新增功能前先分析影响范围、风险和测试清单。
```

Expected behavior:

* Identify domain: `code`
* Suggest name: `code-safe-feature`
* Determine risk: high
* Add `disable-model-invocation: true`
* Generate a standard Skill structure
* Recommend manual invocation

---

### Example 3

```text
帮我安装一个本地 Skill，用来解释 AI 概念，比如 LLM、RAG、Agent、MCP。
```

Expected behavior:

* Identify domain: `learn`
* Suggest name: `learn-concept-explain`
* Determine scope: global
* Determine risk: low
* Generate `SKILL.md`
* Allow automatic invocation unless the user prefers manual only

---

### Example 4

```text
我想把这些 Skill 按最佳实践规范一下，帮我检查命名、description、风险等级和目录结构。
```

Expected behavior:

* Review existing Skill structure
* Check naming consistency
* Check descriptions
* Check high-risk Skills
* Recommend index updates
* Recommend moving experimental Skills out of active directory

---

### Example 5

```text
帮我生成一个 db-migration-review Skill，要求数据库变更前先检查表结构、索引、兼容性和回滚方案。
```

Expected behavior:

* Identify domain: `db`
* Suggest name: `db-migration-review`
* Determine risk: high
* Add `disable-model-invocation: true`
* Include database-specific safety rules
* Require explicit confirmation before migration-related actions

---

### Example 6

```text
请创建一个 ops-release-check Skill，用于上线前检查环境变量、构建结果、数据库状态和回滚方案。
```

Expected behavior:

* Identify domain: `ops`
* Suggest name: `ops-release-check`
* Determine risk: high
* Add `disable-model-invocation: true`
* Avoid running deployment commands directly
* Include release safety checklist

---

### Example 7

```text
请帮我创建一个 Skill 模板，后续给 Codex 和 VSCode AI IDE 用。
```

Expected behavior:

* Treat this as a Skill scaffolding request
* Generate reusable template files
* Include AI IDE usage notes
* Avoid tool-specific assumptions unless provided by the user

---

### Example 8

```text
帮我更新 .claude/SKILLS_INDEX.md，把当前项目里的 Skills 都整理进去。
```

Expected behavior:

* Inspect Skill names and descriptions
* Create or update `SKILLS_INDEX.md`
* Include domain, scope, risk, auto trigger, and purpose
* Flag missing descriptions or risky auto-trigger settings

---

### Example 9

```text
我想开源一个 Skill，帮我检查它的目录结构和文档是否符合最佳实践。
```

Expected behavior:

* Review open-source readiness
* Check for private paths, secrets, tokens, server info, or company-only details
* Check README, LICENSE, CONTRIBUTING, CHANGELOG
* Validate Skill structure

---

### Example 10

```text
帮我创建一个 doc-architecture-update Skill，用于每次代码结构变化后更新架构文档。
```

Expected behavior:

* Identify domain: `doc`
* Suggest name: `doc-architecture-update`
* Determine risk: medium
* Include documentation update workflow
* Include output template for architecture change summary

---

## Should not use this Skill

Do not use `skill-scaffold` when the user is asking to perform the actual task that another Skill should handle.

---

### Non-trigger example 1

```text
帮我评审这个 PRD。
```

Why not:

This should use a PRD review Skill such as:

```text
pm-prd-review
```

It is not asking to create or install a Skill.

---

### Non-trigger example 2

```text
帮我修复这个登录接口的 bug。
```

Why not:

This should use a coding or bug fixing Skill such as:

```text
code-bug-fix
```

It is not asking to create or manage Skills.

---

### Non-trigger example 3

```text
RAG 是什么？产品经理应该怎么理解？
```

Why not:

This should use a learning or concept explanation Skill such as:

```text
learn-concept-explain
```

It is not asking to create a Skill.

---

### Non-trigger example 4

```text
帮我设计这个 App 首页原型。
```

Why not:

This should use a UX or product design Skill such as:

```text
ux-prototype-review
pm-feature-design
```

It is not asking to scaffold a Skill.

---

### Non-trigger example 5

```text
帮我部署后端服务。
```

Why not:

This should use a deployment or release Skill such as:

```text
ops-release-check
```

Even then, deployment commands should require explicit confirmation.

---

### Non-trigger example 6

```text
帮我写一份用户增长方案。
```

Why not:

This is a normal strategy or writing task.

It is not related to creating, installing, validating, or organizing Skills.

---

### Non-trigger example 7

```text
帮我看一下这个 SQL 是否有问题。
```

Why not:

This should use a database review Skill such as:

```text
db-migration-review
db-query-review
```

It is not asking to create a Skill.

---

### Non-trigger example 8

```text
帮我更新 README。
```

Why not:

This may be a documentation task.

Use `skill-scaffold` only if the README update is specifically about documenting the Skill scaffold or Skill installation process.

---

## Ambiguous cases

Some requests may be ambiguous.

Use `skill-scaffold` only if the user is asking to create, install, organize, standardize, validate, or open source a Skill.

---

### Ambiguous example 1

```text
帮我整理一下这些 AI 工作流。
```

How to decide:

Use `skill-scaffold` only if the user wants to turn the workflows into Skills.

If the user only wants a list, summary, or plan, do not use `skill-scaffold`.

---

### Ambiguous example 2

```text
我想规范一下 AI 编码流程。
```

How to decide:

If the user wants to create a reusable Skill, use `skill-scaffold`.

If the user wants general advice, answer normally or use a coding workflow Skill.

---

### Ambiguous example 3

```text
帮我把这个流程沉淀下来。
```

How to decide:

Ask or infer whether the user means:

* Create a Skill
* Create a document
* Create a checklist
* Create a script

Use `skill-scaffold` only when the target is a Skill.

---

## Recommended manual invocation

Because `skill-scaffold` creates or modifies files, it should normally be manually invoked.

Recommended usage:

```text
/skill-scaffold

我要创建一个项目级 Skill：
- domain: code
- name: safe-feature
- risk: high
- purpose: 新增功能前做安全变更分析

先不要创建文件，先输出创建方案。
```

Then, after review:

```text
确认，请按方案创建文件，并更新 SKILLS_INDEX.md。
```

---

## Expected behavior summary

When `skill-scaffold` is used, it should:

1. Clarify or infer the Skill's purpose.
2. Generate a clear Skill name.
3. Decide global or project scope.
4. Decide domain and risk level.
5. Decide whether auto invocation should be disabled.
6. Propose files to create before editing.
7. Generate `SKILL.md` using the standard template.
8. Create supporting directories.
9. Update `SKILLS_INDEX.md`.
10. Validate the result.
11. Provide a usage example.

It should not:

1. Run dangerous commands.
2. Deploy applications.
3. Modify databases.
4. Delete files without explicit confirmation.
5. Access secrets or private credentials.
6. Create large, unfocused Skills.
7. Replace specialized Skills for product, coding, database, or learning tasks.
