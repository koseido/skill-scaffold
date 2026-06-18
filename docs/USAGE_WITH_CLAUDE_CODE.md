# Usage with Claude Code

This guide explains how to use `skill-scaffold` with Claude Code.

---

## 1. Recommended setup

Install `skill-scaffold` globally:

```bash
mkdir -p ~/.claude/skills
cp -R skills/skill-scaffold ~/.claude/skills/
```

On Windows PowerShell:

```powershell
New-Item -ItemType Directory -Force -Path "$HOME/.claude/skills"
Copy-Item -Recurse -Path "skills/skill-scaffold" -Destination "$HOME/.claude/skills/"
```

Then use project-level Skills inside each repository:

```text
your-project/
|- AGENTS.md
|- CLAUDE.md
|- docs/
|  |- SKILL_SPEC.md
|  |- SKILLS_INDEX_SPEC.md
|  `- AI_CODEMAP.md
`- .claude/
   |- SKILLS_INDEX.md
   `- skills/
      |- code-safe-feature/
      |- code-bug-fix/
      |- db-migration-review/
      `- ops-release-check/
```

---

## 2. Why global install is recommended

`skill-scaffold` is a meta Skill.

It helps create and maintain other Skills.

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

I want to create a project-level Skill.
- domain: code
- name: safe-feature
- risk: high
- purpose: Analyze a feature change before editing code.

Do not create files yet.
First output the creation plan.
```

Expected response:

1. Final Skill name
2. Scope
3. Target directory
4. Domain
5. Risk level
6. Whether auto invocation should be disabled
7. Files to create
8. Index entry or index impact
9. Whether scripts are needed
10. Validation checklist

---

## 4. Two-step creation flow

Use a two-step flow for safety.

### Step 1: Plan

```text
/skill-scaffold

I want to create a project-level Skill.
- domain: pm
- name: prd-review
- risk: medium
- purpose: Review product requirement documents for goals, user scenarios, workflows, edge cases, acceptance criteria, and implementation risks.

Do not create files yet.
First output the creation plan.
```

### Step 2: Create

```text
Confirmed. Please create the files according to the plan and update .claude/SKILLS_INDEX.md.
```

This prevents accidental file creation or unsafe behavior.

---

## 5. Recommended project instructions

Add this to `AGENTS.md` or `CLAUDE.md` in your project:

```md
## Skill creation rules

When the user asks to create, install, update, organize, or validate a Skill:

1. Use `/skill-scaffold` if available.
2. Read `docs/SKILL_SPEC.md` and `docs/SKILLS_INDEX_SPEC.md` if they exist.
3. Do not create files immediately.
4. First output:
   - Skill name
   - Scope
   - Domain
   - Risk level
   - Target directory
   - Files to create
   - Whether auto invocation should be disabled
   - SKILLS_INDEX.md impact
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

I want to create a project-level Skill.
- domain: code
- name: safe-feature
- risk: high
- purpose: Before editing code, inspect AGENTS.md and docs/AI_CODEMAP.md, identify affected modules and files, propose a minimal change plan, and produce a regression checklist.

Requirements:
1. High risk, so manual invocation is required
2. Do not create risky scripts
3. Create references, templates, and examples
4. Update .claude/SKILLS_INDEX.md

First output the creation plan.
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

I want to create a project-level Skill.
- domain: pm
- name: prd-review
- risk: medium
- purpose: Review product requirement documents for goals, user scenarios, workflows, edge cases, acceptance criteria, and implementation risks.

Do not create files yet.
First output the creation plan.
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

I want to create a global Skill.
- domain: learn
- name: concept-explain
- risk: low
- purpose: Explain AI, product, and technical concepts in a structured and practical way.

Do not create files yet.
First output the creation plan.
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

Please inspect the current project Skills under .claude/skills and update .claude/SKILLS_INDEX.md according to docs/SKILLS_INDEX_SPEC.md.

Include:
- Skill
- Domain
- Scope
- Status
- Risk
- Auto trigger
- Purpose
```

Recommended index format:

```md
| Skill | Domain | Scope | Status | Risk | Auto trigger | Purpose |
|---|---|---|---|---|---|---|
| code-safe-feature | code | project | active | high | No | Analyze feature changes before editing code |
| pm-prd-review | pm | project | active | medium | Yes | Review product requirement documents |
```

If your repository includes helper scripts, you can also run:

```bash
./scripts/generate-skills-index.sh .claude/skills
./scripts/validate-skill.sh .claude/skills
```

On Windows PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/generate-skills-index.ps1 .claude/skills
powershell -ExecutionPolicy Bypass -File scripts/validate-skill.ps1 .claude/skills
```

---

## 10. Validation prompt

Use:

```text
/skill-scaffold

Please validate all Skills under .claude/skills according to docs/SKILL_SPEC.md and docs/SKILLS_INDEX_SPEC.md.

Check:
1. Directory names are kebab-case
2. Descriptions are specific
3. High-risk Skills include disable-model-invocation: true
4. Purpose / Best for / Not for / Required inputs / Workflow / Output format / Safety rules are present
5. scripts/ does not contain risky commands
6. SKILLS_INDEX.md exists and is current
7. SKILLS_INDEX.md columns match the spec
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
-> Open Claude Code in your project
-> Run /skill-scaffold
-> Ask for a creation plan
-> Confirm file creation
-> Review generated Skill
-> Update SKILLS_INDEX.md
-> Validate
-> Use the new Skill manually or automatically based on risk
```
