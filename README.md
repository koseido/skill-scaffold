# skill-scaffold

`skill-scaffold` is a lightweight repository for creating, installing, reviewing, indexing, and validating local AI Skills with one consistent best-practice system.

It is designed for Claude Code, Codex, and VSCode AI IDE workflows where the number of local Skills keeps growing and ad hoc naming or structure stops scaling.

---

## What this repository is for

Use this repository when you want to:

- Create a new Skill with a standard directory structure
- Install an existing Skill into a global or project Skill directory
- Review a third-party Skill before trusting it
- Normalize Skill naming, descriptions, and risk settings
- Generate or maintain `SKILLS_INDEX.md`
- Validate Skills for structure, safety, and invocation behavior

The main idea is simple:

> Skills should stay easy to find, easy to trigger correctly, safe by default, and easy to maintain over time.

---

## What this repository is not

`skill-scaffold` is not a package manager.

It does not automatically refactor all of your existing Skills, and it should not blindly install remote or unreviewed third-party content.

By default, it is a governance and scaffolding layer for Skills, not an autonomous migration tool.

---

## Current capabilities

This repository currently includes:

- A management Skill: [skills/skill-scaffold/SKILL.md](</C:/00.work/04.code/skill-scaffold/skills/skill-scaffold/SKILL.md>)
- Core Skill specification: [docs/SKILL_SPEC.md](</C:/00.work/04.code/skill-scaffold/docs/SKILL_SPEC.md>)
- Index specification: [docs/SKILLS_INDEX_SPEC.md](</C:/00.work/04.code/skill-scaffold/docs/SKILLS_INDEX_SPEC.md>)
- Installation guide: [docs/INSTALLATION.md](</C:/00.work/04.code/skill-scaffold/docs/INSTALLATION.md>)
- Claude Code guide: [docs/USAGE_WITH_CLAUDE_CODE.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_CLAUDE_CODE.md>)
- Codex guide: [docs/USAGE_WITH_CODEX.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_CODEX.md>)
- VSCode AI IDE guide: [docs/USAGE_WITH_VSCODE_AI_IDE.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_VSCODE_AI_IDE.md>)
- Third-party review checklist: [docs/THIRD_PARTY_SKILL_REVIEW.md](</C:/00.work/04.code/skill-scaffold/docs/THIRD_PARTY_SKILL_REVIEW.md>)
- Bash and PowerShell install scripts
- Bash and PowerShell validation scripts
- Bash and PowerShell `SKILLS_INDEX.md` generation scripts
- Example Skills under [examples](</C:/00.work/04.code/skill-scaffold/examples>)

---

## Repository structure

```text
skill-scaffold/
|- AGENTS.md
|- README.md
|- docs/
|  |- INSTALLATION.md
|  |- SKILL_SPEC.md
|  |- SKILLS_INDEX_SPEC.md
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

## Best-practice model

This repository standardizes a few important behaviors.

### 1. Flat, searchable naming

Prefer:

```text
<domain>-<action>-<object>
```

Examples:

```text
code-safe-feature
pm-prd-review
learn-concept-explain
db-migration-review
ops-release-check
```

Avoid vague names such as:

```text
helper
review
fix
agent
workflow
```

### 2. Trigger-oriented descriptions

Descriptions should explain:

- What the Skill does
- When to use it
- When not to use it
- What keywords should help trigger it

### 3. High-risk Skills require manual invocation

For Skills in domains such as `code`, `db`, and `ops`, the default should usually be:

```yaml
disable-model-invocation: true
```

### 4. `SKILL.md` stays short

Keep `SKILL.md` focused on:

- Purpose
- Best for
- Not for
- Required inputs
- Workflow
- Output format
- Safety rules

Move detailed material into:

- `references/`
- `templates/`
- `examples/`

### 5. Skills should be indexed and validated

Use `SKILLS_INDEX.md` as a navigation layer.

Use the validation scripts to catch:

- Bad naming
- Vague descriptions
- Missing required sections
- Missing high-risk invocation guards
- Risky scripts
- Missing or stale index entries

---

## Installation

### Bash / Unix-like environments

Global install:

```bash
chmod +x scripts/install-skill.sh
./scripts/install-skill.sh --scope global
```

Project install:

```bash
./scripts/install-skill.sh --scope project --target /path/to/your-project
```

### Windows PowerShell

Global install:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install-skill.ps1 -Scope global
```

Project install:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install-skill.ps1 -Scope project -Target C:\path\to\your-project
```

More detail: [docs/INSTALLATION.md](</C:/00.work/04.code/skill-scaffold/docs/INSTALLATION.md>)

---

## Generate and validate the index

Generate `SKILLS_INDEX.md`:

```bash
./scripts/generate-skills-index.sh .claude/skills
```

```powershell
powershell -ExecutionPolicy Bypass -File scripts/generate-skills-index.ps1 .claude/skills
```

Validate Skills:

```bash
./scripts/validate-skill.sh .claude/skills
```

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-skill.ps1 .claude/skills
```

The standard index format is defined in [docs/SKILLS_INDEX_SPEC.md](</C:/00.work/04.code/skill-scaffold/docs/SKILLS_INDEX_SPEC.md>).

---

## Recommended workflow

Use this workflow for new Skills:

1. Read `AGENTS.md`, `docs/SKILL_SPEC.md`, and `docs/SKILLS_INDEX_SPEC.md`.
2. Ask for a plan before creating files.
3. Confirm the final Skill name, scope, risk level, and index impact.
4. Create the Skill files.
5. Generate or update `SKILLS_INDEX.md`.
6. Validate the result.
7. Test the Skill in a real task.

Use this workflow for third-party Skills:

1. Clone or copy the Skill into a temporary review location.
2. Inspect `SKILL.md`, `references/`, `templates/`, `examples/`, and `scripts/`.
3. Review the Skill with [docs/THIRD_PARTY_SKILL_REVIEW.md](</C:/00.work/04.code/skill-scaffold/docs/THIRD_PARTY_SKILL_REVIEW.md>).
4. Decide whether it belongs in `global`, `project`, `lab`, `disabled`, or `archive`.
5. Install it only after review.
6. Update and validate the index.

---

## Example Skills

This repository includes three example Skills:

- [examples/code-safe-feature/SKILL.md](</C:/00.work/04.code/skill-scaffold/examples/code-safe-feature/SKILL.md>)
- [examples/pm-prd-review/SKILL.md](</C:/00.work/04.code/skill-scaffold/examples/pm-prd-review/SKILL.md>)
- [examples/learn-concept-explain/SKILL.md](</C:/00.work/04.code/skill-scaffold/examples/learn-concept-explain/SKILL.md>)

They demonstrate:

- High-risk manual invocation
- Medium-risk review workflows
- Low-risk learning and explanation workflows

---

## Cross-tool usage

This repository supports three primary usage styles:

- Claude Code: manual `/skill-scaffold` flow
- Codex: file-driven flow using `AGENTS.md` plus the docs
- VSCode AI IDEs: rules-driven flow using project docs and prompts

Start with:

- [docs/USAGE_WITH_CLAUDE_CODE.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_CLAUDE_CODE.md>)
- [docs/USAGE_WITH_CODEX.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_CODEX.md>)
- [docs/USAGE_WITH_VSCODE_AI_IDE.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_VSCODE_AI_IDE.md>)

---

## Safety defaults

This repository assumes:

- No remote install scripts
- No `curl | bash`
- No default deployment actions
- No default database execution
- No reading `.env` or SSH keys without explicit approval
- No destructive file operations without confirmation
- No unreviewed third-party scripts in active Skill directories

When in doubt, prefer manual invocation, smaller scope, and explicit review.

---

## Roadmap

Reasonable next additions include:

- Stronger batch validation
- Automatic stale-row detection in indexes
- More example Skills
- Better open-source contribution templates
- Optional lifecycle directory helpers

---

## Summary

`skill-scaffold` helps teams and individuals manage growing Skill libraries without relying on memory or inconsistent conventions.

If you have only a few Skills, ad hoc organization may be enough.

If you have many Skills, this repository gives you a repeatable way to keep them discoverable, safe, and maintainable.
