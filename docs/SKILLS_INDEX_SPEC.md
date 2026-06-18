# SKILLS_INDEX Specification

This document defines the recommended format and update rules for `SKILLS_INDEX.md`.

Use it together with `docs/SKILL_SPEC.md` when creating, reviewing, or validating a local Skill library.

---

## 1. Purpose

`SKILLS_INDEX.md` is a navigation file for humans and AI assistants.

It should make it easy to:

- Find a Skill by name or domain
- Understand where a Skill belongs
- Identify risk and invocation behavior
- See whether a Skill is active, experimental, disabled, or archived

It is not the source of truth for Skill behavior.

The source of truth remains each Skill's `SKILL.md`.

---

## 2. Recommended locations

Use the index nearest to the Skill collection.

Project Skill index:

```text
.claude/SKILLS_INDEX.md
```

Global Skill index:

```text
~/.claude/SKILLS_INDEX.md
```

If a repository contains both project and example Skills, only index the active project Skill directory unless the repository explicitly chooses to track examples as well.

---

## 3. Required table format

Use this header exactly:

```md
| Skill | Domain | Scope | Status | Risk | Auto trigger | Purpose |
|---|---|---|---|---|---|---|
```

Each row represents one Skill directory.

Example:

```md
| code-safe-feature | code | project | active | high | No | Analyze feature changes before editing code |
| pm-prd-review | pm | project | active | medium | Yes | Review product requirement documents |
| learn-concept-explain | learn | global | active | low | Yes | Explain concepts in a structured way |
```

---

## 4. Field rules

### Skill

Use the directory name.

It must match the `name` field in `SKILL.md`.

### Domain

Infer from the first prefix in the Skill name.

Examples:

```text
code-safe-feature -> code
pm-prd-review -> pm
skill-scaffold -> skill
```

If a Skill does not follow the prefix convention, flag it for review instead of guessing silently.

### Scope

Allowed values:

```text
global
project
lab
disabled
archive
```

Interpretation:

- `global`: installed in a global Skill directory
- `project`: installed in a project repository
- `lab`: experimental and not yet promoted to active use
- `disabled`: intentionally disabled
- `archive`: historical or deprecated

If lifecycle directories are used, `Scope` should reflect the actual location or intended lifecycle state.

### Status

Allowed values:

```text
active
experimental
disabled
archived
```

Recommended mapping:

- active Skill directory -> `active`
- `skills-lab/` -> `experimental`
- `skills-disabled/` -> `disabled`
- `skills-archive/` -> `archived`

### Risk

Allowed values:

```text
low
medium
high
```

Infer from Skill behavior, not only from the domain prefix.

Recommended defaults:

- `code`, `db`, `ops` -> usually `high`
- `pm`, `ux`, `doc`, `skill` -> usually `medium`
- `learn` -> usually `low`

When in doubt, prefer the higher risk and explain why.

### Auto trigger

Allowed values:

```text
Yes
No
```

Mapping:

- `disable-model-invocation: true` -> `No`
- field absent or false -> `Yes`

### Purpose

Use a short plain-language summary of the Skill's main job.

Prefer a one-line summary derived from the `description` or `Purpose` section.

Do not copy an overlong description into the table.

---

## 5. Update rules

Update `SKILLS_INDEX.md` when:

- A Skill is created
- A Skill is renamed
- A Skill is moved between scopes
- A Skill changes lifecycle status
- A Skill changes risk level
- A Skill changes invocation policy
- A Skill is substantially repurposed

If the user asks for a review-only pass, propose the index changes without editing the file.

---

## 6. Validation rules

An index is considered healthy when:

- The file exists for the active Skill collection
- The table header matches the standard format
- Every active Skill directory has exactly one row
- Every row references an existing Skill directory
- The `Skill` value matches `SKILL.md` frontmatter `name`
- `Domain` matches the directory prefix
- `Auto trigger` matches `disable-model-invocation`
- `Purpose` is concise and non-empty

Suggested validation severities:

- Error: missing file, malformed header, missing row for an active Skill
- Warning: stale row, mismatched purpose, inferred risk that should be reviewed

---

## 7. Recommended workflow

When creating or updating Skills:

1. Inspect the Skill directory and `SKILL.md`
2. Determine `Domain`, `Scope`, `Status`, `Risk`, and `Auto trigger`
3. Write or update the index row
4. Validate that the row matches the Skill metadata
5. Re-run validation after the Skill change is complete

---

## Summary

`SKILLS_INDEX.md` should stay small, current, and mechanically consistent with the Skill library.

The index is most useful when it is:

- Updated at the same time as Skill changes
- Validated instead of maintained by memory
- Clear enough for both humans and AI tools to scan quickly
