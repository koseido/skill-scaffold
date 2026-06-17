---
name: code-safe-feature
description: Analyze a requested feature change before editing code. Use when adding or modifying features, APIs, pages, database fields, workflows, or UI behavior. Do not use for simple copywriting, one-line style changes, or pure explanation tasks. Keywords: new feature, modify feature, API change, workflow change, before coding, impact analysis.
disable-model-invocation: true
---

# code-safe-feature

## Purpose

Use this Skill before adding or modifying code for a product feature.

The goal is to prevent uncontrolled AI coding by requiring the assistant to inspect context, identify risk, propose a minimal change plan, and produce a regression checklist before making changes.

This Skill is intentionally manual because feature development can affect code, data, user flows, and release safety.

## Best for

Use this Skill when the user wants to:

- Add a new feature
- Modify an existing feature
- Add or change an API
- Change a business workflow
- Add or modify database fields
- Change page behavior
- Touch multiple modules
- Ask for a safe implementation plan before coding

Good example requests:

```text
我要新增【视频上传】功能，先不要改代码，先分析影响范围。
```

```text
我要修改登录流程，先输出需要查看哪些文件和最小变更方案。
```

```text
新增一个后端接口，先做风险分析和回归测试清单。
```

## Not for

Do not use this Skill for:

- Simple copywriting changes
- One-line style tweaks
- Pure concept explanation
- PRD review without code impact
- Database migration execution
- Production deployment
- Large refactoring without a separate refactor plan
- Fixing bugs when the task is specifically a debugging workflow

Use a different Skill when appropriate:

```text
code-bug-fix
code-review
db-migration-review
ops-release-check
pm-prd-review
```

## Required inputs

Collect or infer:

- Feature name
- Target product area or module
- Expected behavior
- Current behavior, if modifying an existing feature
- Whether code changes are allowed now
- Whether database changes may be involved
- Whether API changes may be involved
- Whether UI changes may be involved
- Testing expectations
- Any files, screenshots, tickets, or requirements provided by the user

If key context is missing, make safe assumptions and clearly list them.

Ask a clarifying question only when the missing detail would materially change the implementation scope or create risk.

## Workflow

### Step 1: Read project rules

Before proposing code changes, inspect project guidance if available:

```text
AGENTS.md
CLAUDE.md
README.md
docs/AI_CODEMAP.md
docs/ARCHITECTURE.md
docs/RISK_FILES.md
```

Do not assume all files exist.

If a file does not exist, mention that it was not found and continue with available context.

### Step 2: Understand the feature request

Summarize:

1. What the user wants
2. Why it matters
3. What user flow or system behavior may change
4. What is explicitly requested
5. What is inferred

### Step 3: Identify target module

Determine the likely module or area, such as:

```text
frontend
backend
database
auth
upload
payment
notification
admin
mobile app
API server
worker
scheduler
```

### Step 4: Identify files to inspect

List files that should be inspected before editing.

Group them by type:

```text
Product/UI
API/routes
Services/business logic
Database/models/migrations
Tests
Config
Docs
```

### Step 5: Identify likely files to modify

List files that are likely to change.

Mark confidence level:

```text
High
Medium
Low
```

### Step 6: Check high-risk areas

Check whether the change may affect:

- Authentication
- Authorization
- Payments
- User data
- File upload
- Database schema
- Background jobs
- External APIs
- Production config
- Security-sensitive logic
- Data deletion
- Migration or rollback
- Release scripts

### Step 7: Propose minimal change plan

Provide the smallest safe implementation plan.

The plan should include:

1. What to change
2. What not to change
3. Order of changes
4. Any feature flags or compatibility handling
5. Migration or rollback considerations, if needed

### Step 8: Regression test checklist

Create a checklist covering:

- Happy path
- Empty state
- Error state
- Permission checks
- API validation
- Database compatibility
- UI behavior
- Backward compatibility
- Edge cases
- Logs or monitoring
- Manual verification

### Step 9: Wait for confirmation

Do not modify code until the user confirms.

If the user explicitly asked to proceed directly, still keep changes minimal and explain what will be changed.

## Output format

Return:

```md
## Feature change analysis

### 1. Request summary

### 2. Target module

### 3. Files to inspect

| Area | Files | Reason |
|---|---|---|

### 4. Files likely to modify

| Confidence | Files | Reason |
|---|---|---|

### 5. Risk level

Low / Medium / High

### 6. Risk points

### 7. Minimal change plan

### 8. Regression test checklist

### 9. Assumptions

### 10. Need confirmation?

Yes / No
```

## Safety rules

- Do not edit code before producing the analysis unless the user explicitly asks to proceed directly.
- Do not delete files without explicit confirmation.
- Do not run migrations without explicit confirmation.
- Do not deploy.
- Do not run production commands.
- Do not access secrets, `.env`, SSH keys, or credentials unless explicitly approved.
- Do not broaden the change scope without explaining why.
- Prefer minimal, reversible changes.
- If a database change is needed, recommend using `db-migration-review`.
- If release risk is involved, recommend using `ops-release-check`.

## Example usage

```text
/code-safe-feature

我要新增【视频上传】功能。

先不要修改代码，请先输出：
1. 目标功能属于哪个模块
2. 需要查看哪些文件
3. 预计修改哪些文件
4. 是否会触碰高风险文件
5. 最小变更方案
6. 回归测试清单
```
