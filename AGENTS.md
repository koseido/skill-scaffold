## AI Skill Creation And Validation

This repository defines a local AI Skill scaffolding system.

When the user asks to create, install, review, standardize, index, or validate Skills:

- Read `docs/SKILL_SPEC.md`, `docs/SKILLS_INDEX_SPEC.md`, and `skills/skill-scaffold/SKILL.md` first when they are relevant.
- Treat `skill-scaffold` as a manual-invocation management Skill. Plan before edits unless the user explicitly says to proceed directly.
- Use lowercase kebab-case Skill names and prefer `<domain>-<action>-<object>`.
- Use domain prefixes such as `learn`, `pm`, `ux`, `code`, `db`, `ops`, `doc`, and `skill`.
- Put project Skills under `.claude/skills/<skill-name>/`.
- Keep `SKILL.md` short and move detailed rules into `references/`, reusable formats into `templates/`, and examples into `examples/`.
- Do not create `scripts/` unless deterministic commands are required.
- High-risk Skills in `code`, `db`, and `ops` should normally include `disable-model-invocation: true`.
- Review third-party Skill scripts for risky commands before installation.
- Update `.claude/SKILLS_INDEX.md` or propose an index entry whenever a Skill is created, renamed, moved, disabled, archived, or materially repurposed.
- Prefer ASCII in generated files unless the file already uses another encoding or character set intentionally.

When planning a Skill change, include:

1. Final Skill name
2. Scope and target directory
3. Purpose
4. Risk level
5. Auto invocation policy
6. Files to create or modify
7. `SKILLS_INDEX.md` impact
8. Validation plan

Do not run remote install commands, do not add secrets, and do not use destructive file operations without explicit confirmation.
