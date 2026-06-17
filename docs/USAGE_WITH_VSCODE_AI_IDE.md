# Usage with VSCode AI IDE

This guide explains how to use `skill-scaffold` with AI coding tools inside VSCode, such as Cursor, Cline, Continue, GitHub Copilot Chat, or other AI IDE extensions.

Not every VSCode AI tool supports Claude-style Skills directly.

However, all of them can follow file-based rules if you provide:

```text
docs/SKILL_SPEC.md
AGENTS.md
.claude/skills/<skill-name>/SKILL.md
```

---

## 1. Recommended project structure

Use this structure:

```text
your-project/
├── AGENTS.md
├── docs/
│   ├── SKILL_SPEC.md
│   └── SKILL_USAGE_GUIDE.md
├── scripts/
│   ├── install-skill.sh
│   └── validate-skill.sh
├── .claude/
│   ├── SKILLS_INDEX.md
│   └── skills/
│       ├── code-safe-feature/
│       ├── pm-prd-review/
│       └── learn-concept-explain/
└── .cursor/
    └── rules/
        └── skill-creation.mdc
```

Use only the files supported by your AI IDE.

For example:

- Cursor can use `.cursor/rules/`.
- Codex can use `AGENTS.md`.
- Claude Code can use `.claude/skills/`.
- Copilot Chat can read referenced files if you ask it to.

---

## 2. Core idea

In VSCode AI IDEs, treat `skill-scaffold` as a specification and template system.

The AI should:

1. Read the project rules.
2. Read `docs/SKILL_SPEC.md`.
3. Create Skill files according to the specification.
4. Update `.claude/SKILLS_INDEX.md`.
5. Validate the generated Skill.

---

## 3. Recommended prompt

Use this prompt in your AI IDE:

```text
Please read AGENTS.md and docs/SKILL_SPEC.md first.

I want to create a new project-level Skill.

Skill information:
- domain: code
- name: safe-feature
- risk: high
- purpose: Analyze a feature change before editing code. It should inspect project rules, identify affected modules and files, propose a minimal change plan, and produce a regression checklist.

Do not create files yet.

First output:
1. Final Skill name
2. Target directory
3. Files to create
4. SKILL.md frontmatter
5. Whether disable-model-invocation is required
6. Whether scripts are needed
7. Validation checklist
```

Then:

```text
Confirmed. Please create the files according to the plan, update .claude/SKILLS_INDEX.md, and do not create any scripts unless required.
```

---

## 4. Cursor rules example

If you use Cursor, create:

```text
.cursor/rules/skill-creation.mdc
```

Suggested content:

```md
---
description: Rules for creating and validating local AI Skills
globs:
  - ".claude/skills/**"
  - "docs/SKILL_SPEC.md"
  - ".claude/SKILLS_INDEX.md"
alwaysApply: false
---

# Skill creation rules

When creating, installing, updating, organizing, or validating Skills:

1. Read `docs/SKILL_SPEC.md`.
2. Use `.claude/skills/<skill-name>/SKILL.md`.
3. Use lowercase kebab-case names.
4. Prefer `<domain>-<action>-<object>`.
5. Use domain prefixes: learn, pm, ux, code, db, ops, doc, skill.
6. High-risk Skills for code/db/ops should include `disable-model-invocation: true`.
7. Keep `SKILL.md` short.
8. Use `references/`, `templates/`, and `examples/`.
9. Create `scripts/` only when needed.
10. Update `.claude/SKILLS_INDEX.md`.
11. Do not add risky scripts without explicit approval.
12. Validate after creation.
```

---

## 5. Continue or Cline usage

For tools that use chat-based instructions, paste this before asking for file creation:

```text
You are creating local AI Skills for this repository.

Follow docs/SKILL_SPEC.md.

Rules:
- Create Skills under .claude/skills/<skill-name>/
- Every Skill must have SKILL.md
- Use lowercase kebab-case
- Prefer <domain>-<action>-<object>
- High-risk Skills must include disable-model-invocation: true
- Create references/templates/examples by default
- Do not create scripts unless needed
- Update .claude/SKILLS_INDEX.md
- Plan before editing files
```

---

## 6. GitHub Copilot Chat usage

Copilot Chat may need explicit file references.

Use prompts like:

```text
Read #file:docs/SKILL_SPEC.md first.

Create a project-level Skill:
- domain: pm
- name: prd-review
- risk: medium
- purpose: Review product requirement documents for goals, user scenarios, workflows, edge cases, acceptance criteria, and implementation risks.

Create:
- .claude/skills/pm-prd-review/SKILL.md
- .claude/skills/pm-prd-review/references/README.md
- .claude/skills/pm-prd-review/templates/output-template.md
- .claude/skills/pm-prd-review/examples/trigger-examples.md

Update:
- .claude/SKILLS_INDEX.md

Do not create scripts.
```

---

## 7. Creating a learning Skill

Prompt:

```text
Please read docs/SKILL_SPEC.md.

Create a global-style example Skill under examples/learn-concept-explain/.

Purpose:
Explain AI, product, or technical concepts in a structured way.

Requirements:
- name: learn-concept-explain
- risk: low
- automatic invocation allowed
- include Purpose, Best for, Not for, Required inputs, Workflow, Output format, Safety rules
```

---

## 8. Creating a high-risk code Skill

Prompt:

```text
Please read docs/SKILL_SPEC.md.

Create a project-level Skill under .claude/skills/code-safe-feature/.

Purpose:
Before editing code, analyze a requested feature change, identify affected modules and files, propose a minimal change plan, and produce a regression checklist.

Requirements:
- name: code-safe-feature
- risk: high
- include disable-model-invocation: true
- do not create scripts
- update .claude/SKILLS_INDEX.md
```

---

## 9. Validating Skills in VSCode AI IDE

Ask:

```text
Please validate all Skills under .claude/skills according to docs/SKILL_SPEC.md.

Return a table with:
- Skill
- Issue
- Severity
- Suggested fix

Check:
1. Missing SKILL.md
2. Missing name
3. Missing description
4. Vague description
5. Missing required sections
6. High-risk Skill without disable-model-invocation
7. Unnecessary scripts
8. Risky script commands
9. Missing SKILLS_INDEX.md entry
```

---

## 10. Recommended validation table

Use this output format:

```md
| Skill | Severity | Issue | Suggested fix |
|---|---|---|---|
| code-safe-feature | high | Missing disable-model-invocation | Add disable-model-invocation: true |
| pm-prd-review | medium | Description is too vague | Rewrite description with use and non-use cases |
```

---

## 11. Common VSCode AI IDE mistakes

### Mistake 1: Creating files without a plan

Fix:

```text
First output the creation plan. Do not edit files yet.
```

### Mistake 2: Creating too many scripts

Fix:

```text
Do not create scripts unless deterministic commands are required.
```

### Mistake 3: Ignoring risk level

Fix:

```text
For code, db, and ops Skills, include disable-model-invocation: true unless there is a clear reason not to.
```

### Mistake 4: Putting everything into SKILL.md

Fix:

```text
Keep SKILL.md short. Move long details into references/.
```

### Mistake 5: Not updating the index

Fix:

```text
Update .claude/SKILLS_INDEX.md after creating or renaming a Skill.
```

---

## 12. Recommended workflow summary

Use this flow:

```text
Write docs/SKILL_SPEC.md
↓
Add AI IDE rules if supported
↓
Ask AI to plan Skill creation
↓
Review plan
↓
Confirm file creation
↓
Ask AI to validate the generated Skill
↓
Commit changes
```

For VSCode AI IDEs, the key is to make Skill creation rules explicit in files the AI can read.
