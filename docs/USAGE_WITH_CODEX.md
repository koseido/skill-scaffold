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
|- AGENTS.md
|- docs/
|  |- SKILL_SPEC.md
|  `- SKILLS_INDEX_SPEC.md
|- scripts/
|  |- install-skill.sh
|  |- install-skill.ps1
|  |- validate-skill.sh
|  |- validate-skill.ps1
|  |- generate-skills-index.sh
|  `- generate-skills-index.ps1
`- .claude/
   |- SKILLS_INDEX.md
   `- skills/
```

For Codex, the most important files are:

```text
AGENTS.md
docs/SKILL_SPEC.md
docs/SKILLS_INDEX_SPEC.md
skills/skill-scaffold/SKILL.md
```

---

## 2. Put Skill rules in AGENTS.md

Codex works best when persistent project instructions are written into `AGENTS.md`.

The repository-level `AGENTS.md` should define:

- plan before file changes unless the user explicitly says to proceed directly
- default project-level installation into `.claude/skills/`
- review before third-party GitHub Skill installation
- index update and validation after install
- concise final reporting of what was installed and whether validation passed

---

## 3. Recommended prompt for Codex

For the simplified GitHub install flow, use this prompt:

```text
Please install the Skill from this GitHub repository using the skill-scaffold standard:
https://github.com/xxx/yyy
```

This is the preferred short form.

The default behavior should be:

1. Review the candidate Skill before installing it
2. If the repository contains multiple Skills, choose the most relevant one when there is one clear best match and report which one was chosen
3. Install into the current repository's `.claude/skills/`
4. Generate or update `.claude/SKILLS_INDEX.md`
5. Validate the installed Skills after installation
6. Return:
   - installed Skill name
   - installed target path
   - whether the index was updated
   - validation result

Only ask the user a follow-up question when:

- the repository contains multiple equally plausible Skills
- the user clearly needs global installation instead of project installation
- the repository does not contain a valid Skill structure

---

## 4. Expanded prompt when you want more control

Use this form when you want to override the default behavior:

```text
Please install the Skill from this GitHub repository using the skill-scaffold standard:
https://github.com/xxx/yyy

Requirements:
1. Review the Skill before installing it
2. If the repository contains multiple Skills, tell me which one you selected
3. Install it into the current project's `.claude/skills/`
4. Generate or update `.claude/SKILLS_INDEX.md`
5. Validate after installation
6. Tell me:
   - which Skill was installed
   - where it was installed
   - whether the index was updated
   - the validation result
```

---

## 5. Creating the scaffold files with Codex

If your project does not yet have the scaffold files, ask Codex:

```text
Please create a lightweight Skill scaffolding setup.

Create:
1. docs/SKILL_SPEC.md
2. docs/SKILLS_INDEX_SPEC.md
3. scripts/install-skill.sh
4. scripts/install-skill.ps1
5. scripts/validate-skill.sh
6. scripts/validate-skill.ps1
7. scripts/generate-skills-index.sh
8. scripts/generate-skills-index.ps1
9. .claude/SKILLS_INDEX.md

Requirements:
- Use lowercase kebab-case names
- Support domain prefixes: learn, pm, ux, code, db, ops, doc, skill
- High-risk domains code/db/ops should require disable-model-invocation: true
- Create references/templates/examples by default
- Do not create scripts inside generated Skills unless needed
- Validate Skill naming, description, required sections, risky scripts, and index consistency
- Do not include secrets, personal paths, or private server info

First output the plan before editing files.
```

---

## 6. Using Codex to create a code Skill

Prompt:

```text
Please read AGENTS.md, docs/SKILL_SPEC.md, and docs/SKILLS_INDEX_SPEC.md.

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

## 7. Using Codex to validate Skills

Prompt:

```text
Please validate all Skills under .claude/skills according to docs/SKILL_SPEC.md and docs/SKILLS_INDEX_SPEC.md.

Check:
1. Directory names are lowercase kebab-case
2. SKILL.md exists
3. Frontmatter has name and description
4. Description is specific
5. Required sections exist
6. High-risk Skills include disable-model-invocation: true
7. Scripts do not contain risky commands
8. SKILLS_INDEX.md is up to date and matches Skill metadata

Return a table of issues and suggested fixes.
```

---

## 8. Using Codex to update SKILLS_INDEX.md

Prompt:

```text
Please inspect .claude/skills and update .claude/SKILLS_INDEX.md according to docs/SKILLS_INDEX_SPEC.md.

Use this format:

| Skill | Domain | Scope | Status | Risk | Auto trigger | Purpose |
|---|---|---|---|---|---|---|

Infer:
- Domain from the first prefix
- Scope as project
- Status as active unless the Skill is in a lifecycle directory
- Risk from domain and SKILL.md
- Auto trigger from disable-model-invocation
- Purpose from description
```

---

## 9. Codex-specific cautions

### Codex may not know Claude Skill conventions by default

Always provide:

```text
docs/SKILL_SPEC.md
docs/SKILLS_INDEX_SPEC.md
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

---

## 10. Recommended AGENTS.md snippet

Add this to your project:

```md
## AI Skill creation and validation

This repository uses local AI Skills.

When creating or updating Skills:

- Follow `docs/SKILL_SPEC.md`.
- Follow `docs/SKILLS_INDEX_SPEC.md`.
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
- For GitHub installs, review first, then install into `.claude/skills/`, update the index, and validate the result.
```

---

## 11. Recommended workflow summary

Use this flow with Codex:

```text
Write rules into AGENTS.md
-> Create docs/SKILL_SPEC.md and docs/SKILLS_INDEX_SPEC.md
-> Ask Codex to install the GitHub Skill with the skill-scaffold standard
-> Review the reported selected Skill and install result
-> Ask Codex to validate generated Skill if needed
-> Commit changes
```

Codex should be treated as a file creation and Skill management assistant guided by the Skill specification.
