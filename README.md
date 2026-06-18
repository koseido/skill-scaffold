# skill-scaffold

[English](./README.md) | [简体中文](./README.zh-CN.md)

`skill-scaffold` is a best-practice system for managing local AI Skills when the number of installed Skills keeps growing.

It helps users create, install, review, organize, index, and validate Skills in a more consistent way, so Skills stay easier to find, safer to use, and more maintainable over time.

---

## Background

When you only have a few local Skills, lightweight organization is usually enough.

You can remember them by name:

```text
code-review
prd-review
concept-explain
```

But once Skill usage becomes routine, the number of installed Skills tends to grow quickly:

```text
learn-concept-explain
pm-prd-review
pm-feature-design
ux-prototype-review
code-safe-feature
code-bug-fix
code-review
db-migration-review
ops-release-check
doc-architecture-update
...
```

At that point, the problem is no longer "do I have a Skill for this?".

The real problems become:

- Which Skill should be used for this task?
- How does the AI know when to trigger one Skill instead of another?
- How do I avoid vague names and vague descriptions?
- How do I keep high-risk Skills from being misused?
- How do I separate global Skills from project Skills?
- How do I keep my Skill library understandable after it grows?
- How do I make Skills work consistently across Claude Code, Codex, and VSCode AI IDEs?

This repository exists for that stage.

---

## Why This Exists

Most users do not only need "more Skills".

They need a better way to manage the Skills they already have or plan to install.

Without a management standard, local Skills easily drift into a hard-to-maintain collection of vague folders and prompts:

```text
helper
review
fix
agent
workflow
my-skill
```

That usually leads to:

- poor discoverability
- accidental overlap between Skills
- weak trigger quality
- unsafe default behavior
- inconsistent structure from one Skill to another
- difficulty sharing Skills with teammates

`skill-scaffold` is meant to solve that management problem.

---

## What skill-scaffold Is

`skill-scaffold` is not just an installer.

It is a Skill management scaffold and best-practice workflow for local AI Skills.

It gives users a repeatable way to manage Skills from the moment they are created or installed, instead of waiting until the library becomes messy.

In practical terms, it is:

- a management Skill: [skills/skill-scaffold/SKILL.md](</C:/00.work/04.code/skill-scaffold/skills/skill-scaffold/SKILL.md>)
- a Skill specification: [docs/SKILL_SPEC.md](</C:/00.work/04.code/skill-scaffold/docs/SKILL_SPEC.md>)
- an index specification: [docs/SKILLS_INDEX_SPEC.md](</C:/00.work/04.code/skill-scaffold/docs/SKILLS_INDEX_SPEC.md>)
- install, index, and validation scripts
- example Skills and usage guides

---

## What It Can Do

`skill-scaffold` helps at both creation time and installation time.

### When creating a Skill

It helps you:

- choose a clear Skill name
- write a trigger-oriented description
- decide whether the Skill should be global or project-level
- assign a reasonable risk level
- decide whether auto invocation should be disabled
- generate a standard Skill structure
- keep `SKILL.md` short and move details into supporting files

### When installing a Skill

It helps you:

- review a third-party Skill before trusting it
- install a Skill into the right place
- normalize naming and structure when needed
- generate or update `SKILLS_INDEX.md`
- validate the Skill after installation

### When managing a growing Skill library

It helps you:

- keep names flat and searchable
- reduce overlap between Skills
- keep high-risk Skills manually invoked
- maintain a consistent directory structure
- keep an index that humans and AI tools can both use

---

## What It Does Not Do

`skill-scaffold` does not automatically take over all of your existing Skills.

By default, it does not:

- silently refactor your whole Skill library
- blindly trust GitHub repositories
- run remote install scripts
- bypass review for risky third-party Skills
- auto-execute high-risk scripts

It is a governance layer, not a blind automation layer.

---

## What Value It Delivers

The value of `skill-scaffold` is not only that it can create or install a Skill.

Its real value is that it helps users keep a growing Skill system usable.

That means:

- Skills become easier to find
- Skills become easier to trigger correctly
- High-risk Skills become safer to manage
- New Skills start with better defaults
- Teams can share a more consistent standard
- Large Skill libraries remain maintainable instead of turning into prompt clutter

In short:

> When you have only a few Skills, memory may be enough.  
> When you have many Skills, you need a system.  
> `skill-scaffold` is that system's starting point.

---

## Who It Is For

This repository is especially useful for:

- individual users with many local Skills
- developers building project-specific AI workflows
- product managers or AI power users who keep installing new Skills
- teams that want one shared Skill standard
- users who install Skills from GitHub and want a safer review-and-install flow

---

## Current Capabilities

This repository currently includes:

- A management Skill: [skills/skill-scaffold/SKILL.md](</C:/00.work/04.code/skill-scaffold/skills/skill-scaffold/SKILL.md>)
- Core Skill specification: [docs/SKILL_SPEC.md](</C:/00.work/04.code/skill-scaffold/docs/SKILL_SPEC.md>)
- Index specification: [docs/SKILLS_INDEX_SPEC.md](</C:/00.work/04.code/skill-scaffold/docs/SKILLS_INDEX_SPEC.md>)
- Installation guide: [docs/INSTALLATION.md](</C:/00.work/04.code/skill-scaffold/docs/INSTALLATION.md>)
- Claude Code guide: [docs/USAGE_WITH_CLAUDE_CODE.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_CLAUDE_CODE.md>)
- Codex guide: [docs/USAGE_WITH_CODEX.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_CODEX.md>)
- VSCode AI IDE guide: [docs/USAGE_WITH_VSCODE_AI_IDE.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_VSCODE_AI_IDE.md>)
- Third-party review checklist: [docs/THIRD_PARTY_SKILL_REVIEW.md](</C:/00.work/04.code/skill-scaffold/docs/THIRD_PARTY_SKILL_REVIEW.md>)
- SKILLS_INDEX template: [docs/SKILLS_INDEX_TEMPLATE.md](</C:/00.work/04.code/skill-scaffold/docs/SKILLS_INDEX_TEMPLATE.md>)
- Bash and PowerShell install scripts
- Bash and PowerShell validation scripts
- Bash and PowerShell `SKILLS_INDEX.md` generation scripts
- Example Skills under [examples](</C:/00.work/04.code/skill-scaffold/examples>)

---

## Repository Structure

```text
skill-scaffold/
|- AGENTS.md
|- README.md
|- docs/
|  |- INSTALLATION.md
|  |- SKILL_SPEC.md
|  |- SKILLS_INDEX_SPEC.md
|  |- SKILLS_INDEX_TEMPLATE.md
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

## Recommended Workflow

Use this workflow for new Skills:

1. Read `AGENTS.md`, `docs/SKILL_SPEC.md`, and `docs/SKILLS_INDEX_SPEC.md`
2. Ask for a plan before creating files
3. Confirm the final Skill name, scope, risk level, and index impact
4. Create the Skill files
5. Generate or update `SKILLS_INDEX.md`
6. Validate the result
7. Test the Skill in a real task

Use this workflow for third-party Skills:

1. Clone or copy the Skill source into a temporary review location
2. Inspect `SKILL.md`, `references/`, `templates/`, `examples/`, and `scripts/`
3. Review it with [docs/THIRD_PARTY_SKILL_REVIEW.md](</C:/00.work/04.code/skill-scaffold/docs/THIRD_PARTY_SKILL_REVIEW.md>)
4. Decide whether it belongs in `global`, `project`, `lab`, `disabled`, or `archive`
5. Install it only after review
6. Generate or update `SKILLS_INDEX.md`
7. Validate the result

---

## Cross-Tool Usage

This repository supports three primary usage styles:

- Claude Code: manual `/skill-scaffold` flow
- Codex: file-driven flow using `AGENTS.md` plus the docs
- VSCode AI IDEs: rules-driven flow using project docs and prompts

Start with:

- [docs/USAGE_WITH_CLAUDE_CODE.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_CLAUDE_CODE.md>)
- [docs/USAGE_WITH_CODEX.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_CODEX.md>)
- [docs/USAGE_WITH_VSCODE_AI_IDE.md](</C:/00.work/04.code/skill-scaffold/docs/USAGE_WITH_VSCODE_AI_IDE.md>)

---

## Safety Defaults

This repository assumes:

- no remote install scripts
- no `curl | bash`
- no default deployment actions
- no default database execution
- no reading `.env` or SSH keys without explicit approval
- no destructive file operations without confirmation
- no unreviewed third-party scripts in active Skill directories

When in doubt, prefer manual invocation, smaller scope, and explicit review.

---

## Summary

`skill-scaffold` is for the stage where local AI Skills are no longer a small personal collection.

It helps users manage Skill creation and installation with best practices from the beginning, so Skills remain easier to use, easier to scale, and safer to maintain.

## Acknowledgements

[LINUX DO — Chinese Developer Community](https://linux.do/) 
