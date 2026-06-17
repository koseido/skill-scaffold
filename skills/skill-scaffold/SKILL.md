---
name: skill-scaffold
description: Create, install, review, standardize, index, and validate local AI Skills using a safe flat naming convention. Use when creating new Skills, installing third-party Skills, organizing Claude Code Skills, updating SKILLS_INDEX.md, or checking Skill best practices. Do not use for ordinary coding, PRD review, deployment, database migration, or broad task execution. Keywords: create skill, install skill, skill best practices, SKILLS_INDEX, validate skill, Claude Code skills.
---

# skill-scaffold

## Purpose

Help the user create, install, organize, review, standardize, index, and validate local AI Skills according to one consistent best-practice system.

This Skill is a management scaffold for other Skills. It should keep Skill directories flat, names searchable, descriptions trigger-oriented, high-risk Skills manually invoked, and `SKILL.md` files short enough to remain useful in context.

Detailed rules are stored in `references/skill-best-practices.md`. Use that file when the user asks for a full standards review or when creating a non-trivial Skill.

## Best for

Use this Skill when the user wants to:

- Create a new global or project Skill
- Install an existing Skill into `~/.claude/skills/` or `.claude/skills/`
- Review a third-party Skill before installing it
- Convert a nested Skill layout into flat prefix-based naming
- Improve a Skill name, description, structure, or safety behavior
- Decide whether a Skill should be global, project-level, lab, disabled, or archived
- Update or create `SKILLS_INDEX.md`
- Validate Skill frontmatter, required sections, high-risk settings, and script safety
- Generate a standard `SKILL.md` from `templates/SKILL.template.md`

## Not for

Do not use this Skill for:

- Ordinary product feature coding
- Bug fixing in application code
- PRD review as the primary task
- UI prototype review as the primary task
- Database migration design or execution
- Deployment, release, or environment changes
- Running third-party scripts without review
- Creating broad multi-purpose agent workflows that should be split into smaller Skills

Use a more specific Skill when appropriate, such as:

```text
code-safe-feature
code-bug-fix
code-review
db-migration-review
ops-release-check
pm-prd-review
ux-prototype-review
```

## Required inputs

Collect or infer:

- Operation type: create, install, review, standardize, index, validate, disable, archive, or document
- Scope: global, project, lab, disabled, or archive
- Target directory, such as `~/.claude/skills/` or `.claude/skills/`
- Domain prefix, such as `learn`, `pm`, `ux`, `code`, `db`, `ops`, `doc`, `biz`, or `skill`
- Proposed action-object name
- Purpose of the Skill
- Risk level: low, medium, or high
- Whether automatic invocation should be disabled
- Whether supporting files or scripts are needed
- Whether existing files may be modified

If information is missing, make a safe recommendation and list assumptions. Ask for confirmation before creating, moving, overwriting, or deleting files.

## Workflow

1. Identify the user's operation: create, install, review, standardize, index, validate, or lifecycle management.
2. Determine scope and target directory.
3. Normalize the Skill name using flat lowercase kebab-case, preferably `<domain>-<action>-<object>`.
4. Check whether the domain prefix is clear and searchable.
5. Write or review the description using: what it does + when to use it + when not to use it + keywords.
6. Determine risk level and whether `disable-model-invocation: true` is required.
7. Keep `SKILL.md` focused on purpose, fit, inputs, workflow, output, and safety.
8. Move detailed rules into `references/`, output formats into `templates/`, and examples into `examples/`.
9. Avoid creating `scripts/` unless deterministic commands are necessary.
10. If scripts exist, inspect them for risky commands, secret access, network access, deployment, destructive file operations, or git history changes.
11. Update or propose an entry for `SKILLS_INDEX.md`.
12. Run or recommend validation after changes.
13. Summarize created files, changed files, risks, and next steps.

## Output format

For planning before edits, return:

```md
## Skill plan

### 1. Final skill name

### 2. Scope and target directory

### 3. Purpose

### 4. Risk level

### 5. Auto invocation

### 6. Files to create or modify

### 7. Index entry

### 8. Validation plan

### 9. Need confirmation?
```

For reviewing an existing Skill, return:

```md
## Skill review

### 1. Overall judgment

Pass / Needs changes / Do not install yet

### 2. Blocking issues

### 3. Recommended improvements

### 4. Naming and description check

### 5. Risk and safety check

### 6. Structure check

### 7. Index and lifecycle recommendation

### 8. Next steps
```

For completed changes, return:

```md
## Skill update summary

### 1. Changed files

### 2. What changed

### 3. Validation result

### 4. Remaining risks

### 5. Next steps
```

## Safety rules

- Do not overwrite an existing Skill unless the user explicitly confirms.
- Do not delete or move Skills without explicit confirmation.
- Do not execute third-party install scripts or remote commands.
- Do not use `curl | bash` installation flows.
- Do not create scripts unless they are necessary, deterministic, and easy to review.
- Do not include secrets, tokens, `.env`, SSH keys, private URLs, or personal absolute paths in generated Skills.
- High-risk Skills in `code`, `db`, and `ops` should usually include `disable-model-invocation: true`.
- Treat scripts containing `rm -rf`, `curl`, `wget`, `ssh`, `scp`, `git push`, `git reset --hard`, `sudo`, `chmod 777`, `.env`, `~/.ssh`, `id_rsa`, `id_ed25519`, upload, deploy, or production references as risky.
- Prefer installing untrusted third-party Skills into `skills-lab/` before promoting them to active `skills/`.
- Keep active Skill directories small, stable, and intentional.

## Supporting files

Use these local supporting files when needed:

```text
references/skill-best-practices.md
templates/SKILL.template.md
templates/output-template.md
examples/trigger-examples.md
```

Use `references/skill-best-practices.md` for the complete rule set.

Use `templates/SKILL.template.md` when generating a new Skill.

Use `templates/output-template.md` when the user wants a standard scaffold output.

Use `examples/trigger-examples.md` when the user wants invocation examples.

## Validation checklist

Before considering a Skill ready, check:

- [ ] Directory name uses lowercase kebab-case.
- [ ] Directory name follows flat prefix naming instead of nested category directories.
- [ ] `SKILL.md` exists.
- [ ] Frontmatter starts and ends with `---`.
- [ ] Frontmatter includes `name`.
- [ ] Frontmatter `name` matches the directory name.
- [ ] Frontmatter includes a specific `description`.
- [ ] Description includes what it does, when to use it, when not to use it, and keywords.
- [ ] High-risk Skills include `disable-model-invocation: true`.
- [ ] `SKILL.md` includes `Purpose`, `Best for`, `Not for`, `Required inputs`, `Workflow`, `Output format`, and `Safety rules`.
- [ ] Long supporting material is moved out of `SKILL.md`.
- [ ] Unnecessary scripts are absent.
- [ ] Existing scripts have been reviewed for risky commands.
- [ ] `SKILLS_INDEX.md` is updated or an index entry is proposed.
- [ ] Lifecycle placement is appropriate: active, lab, disabled, or archive.

## Example usage

```text
/skill-scaffold

我要创建一个项目级 Skill：
- domain: code
- name: safe-feature
- risk: high
- purpose: 新增功能前做安全变更分析

先不要创建文件，先输出创建方案。
```

```text
/skill-scaffold

我从 GitHub 下载了一个 Skill，路径是：
.claude/skills/code-review/

请先检查是否符合最佳实践，只输出问题和优化建议，不要修改文件。
```

```text
/skill-scaffold

请帮我把当前项目 `.claude/skills/` 里的 Skills 做一次索引整理，生成或更新 `.claude/SKILLS_INDEX.md`。修改前先列出计划。
```
