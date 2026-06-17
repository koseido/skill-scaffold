# Usage with Codex

This guide explains how to use `skill-scaffold` concepts with Codex or other OpenAI coding agents.

Codex may not natively invoke Claude-style Skills with `/skill-name`, but it can still read Skill files and follow them as project instructions.

The recommended approach is:

```text
Use skill-scaffold as a file-based specification for creating and maintaining Skills.
```

---

## 1. Recommended setup

Place this repository in your workspace or install `skill-scaffold` into your home directory.

Recommended project structure:

```text
your-project/
├── AGENTS.md
├── docs/
│   └── SKILL_SPEC.md
├── scripts/
│   ├── install-skill.sh
│   └── validate-skill.sh
└── .claude/
    ├── SKILLS_INDEX.md
    └── skills/
```

For Codex, the most important files are:

```text
AGENTS.md
docs/SKILL_SPEC.md
skills/skill-scaffold/SKILL.md
```

---

## 2. Put Skill rules in AGENTS.md

Codex works best when persistent project instructions are written into `AGENTS.md`.

Add this section:

```md
## Skill creation workflow

When the user asks to create, install, update, organize, or validate a Skill:

1. Read `docs/SKILL_SPEC.md` if it exists.
2. If available, read `skills/skill-scaffold/SKILL.md` or `~/.claude/skills/skill-scaffold/SKILL.md`.
3. Do not create files immediately.
4. First output a creation plan:
   - Skill name
   - Scope
   - Domain
   - Risk level
   - Target directory
   - Files to create
   - Whether auto invocation should be disabled
   - Whether scripts are needed
5. Wait for confirmation unless the user explicitly says to proceed directly.
6. Create the Skill under `.claude/skills/<skill-name>/` for project Skills.
7. Update `.claude/SKILLS_INDEX.md`.
8. Create `scripts/` only when deterministic commands are required.
9. Do not add risky scripts without explicit approval.
10. Validate the result after creation.
```

---

## 3. Recommended prompt for Codex

Use this prompt when creating a new Skill:

```text
Please read AGENTS.md and docs/SKILL_SPEC.md first.

I want to create a new project-level Skill.

Skill information:
- domain: code
- name: safe-feature
- risk: high
- purpose: Analyze a feature change before editing code. It should identify the target module, files to inspect, files likely to change, risk level, minimal change plan, and regression checklist.

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

After reviewing the plan:

```text
Confirmed. Please create the files according to the plan, update .claude/SKILLS_INDEX.md, and do not create any risky scripts.
```

---

## 4. Creating the scaffold files with Codex

If your project does not yet have the scaffold files, ask Codex:

```text
Please create a lightweight Skill scaffolding setup.

Create:
1. docs/SKILL_SPEC.md
2. scripts/install-skill.sh
3. scripts/validate-skill.sh
4. .claude/SKILLS_INDEX.md

Requirements:
- Use lowercase kebab-case names
- Support domain prefixes: learn, pm, ux, code, db, ops, doc, skill
- High-risk domains code/db/ops should require disable-model-invocation: true
- Create references/templates/examples by default
- Do not create scripts inside generated Skills unless needed
- Validate Skill naming, description, required sections, and risky scripts
- Do not include secrets, personal paths, or private server info

First output the plan before editing files.
```

---

## 5. Using Codex to create a code Skill

Prompt:

```text
Please read AGENTS.md and docs/SKILL_SPEC.md.

Create a project-level Skill:
- domain: code
- name: safe-feature
- risk: high
- purpose: Before adding or modifying a feature, inspect project rules, identify affected modules and files, propose a minimal change plan, and produce a regression checklist.

Requirements:
1. Target path: .claude/skills/code-safe-feature/
2. Add disable-model-invocation: true
3. Create SKILL.md
4. Create references/README.md
5. Create templates/output-template.md
6. Create examples/trigger-examples.md
7. Update .claude/SKILLS_INDEX.md
8. Do not create scripts
9. Show all files created
```

---

## 6. Using Codex to validate Skills

Prompt:

```text
Please validate all Skills under .claude/skills according to docs/SKILL_SPEC.md.

Check:
1. Directory names are lowercase kebab-case
2. SKILL.md exists
3. Frontmatter has name and description
4. Description is specific
5. Required sections exist
6. High-risk Skills include disable-model-invocation: true
7. Scripts do not contain risky commands
8. SKILLS_INDEX.md is up to date

Return a table of issues and suggested fixes.
```

---

## 7. Using Codex to update SKILLS_INDEX.md

Prompt:

```text
Please inspect .claude/skills and update .claude/SKILLS_INDEX.md.

Use this format:

| Skill | Domain | Scope | Risk | Auto trigger | Purpose |
|---|---|---|---|---|---|

Infer:
- Domain from the first prefix
- Scope as project
- Risk from domain and SKILL.md
- Auto trigger from disable-model-invocation
- Purpose from description
```

---

## 8. Codex-specific cautions

### Codex may not know Claude Skill conventions by default

Always provide:

```text
docs/SKILL_SPEC.md
```

or ask it to read:

```text
skills/skill-scaffold/SKILL.md
```

### Codex may create too much

Tell it explicitly:

```text
Do not create scripts unless needed.
Do not add dependencies.
Do not add install logic beyond file copying.
Do not include private paths or secrets.
```

### Codex may skip safety frontmatter

For high-risk domains, explicitly say:

```text
High-risk Skills must include disable-model-invocation: true.
```

### Codex may modify too many files

Use a two-step flow:

```text
Plan first.
Wait for confirmation.
Then create files.
```

---

## 9. Recommended AGENTS.md snippet

Add this to your project:

```md
## AI Skill creation and validation

This repository uses local AI Skills.

When creating or updating Skills:

- Follow `docs/SKILL_SPEC.md`.
- Use `.claude/skills/<skill-name>/SKILL.md`.
- Use lowercase kebab-case names.
- Prefer `<domain>-<action>-<object>`.
- Use domain prefixes: learn, pm, ux, code, db, ops, doc, skill.
- High-risk domains code/db/ops must normally include `disable-model-invocation: true`.
- Keep `SKILL.md` short.
- Put detailed rules into `references/`.
- Put reusable output formats into `templates/`.
- Put examples into `examples/`.
- Create `scripts/` only when needed.
- Update `.claude/SKILLS_INDEX.md`.
- Do not add risky scripts without approval.
```

---

## 10. Recommended workflow summary

Use this flow with Codex:

```text
Write rules into AGENTS.md
↓
Create docs/SKILL_SPEC.md
↓
Ask Codex to plan the new Skill
↓
Review plan
↓
Confirm file creation
↓
Ask Codex to validate generated Skill
↓
Commit changes
```

Codex should be treated as a file creation assistant guided by the Skill specification.
