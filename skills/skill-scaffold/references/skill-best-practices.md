# Skill Best Practices

This document defines the best practices for creating, installing, organizing, and validating local AI Skills.

It is intended to be used by the `skill-scaffold` Skill when generating new Skills or standardizing existing Skills.

## Core idea

A Skill is not a traditional software package.

A Skill is a structured, reusable workflow package that can be discovered and used by an AI coding assistant or AI IDE.

At minimum, a Skill contains:

```text
<skill-name>/
└── SKILL.md
```

A more complete Skill may contain:

```text
<skill-name>/
├── SKILL.md
├── references/
│   └── README.md
├── templates/
│   └── output-template.md
├── examples/
│   └── trigger-examples.md
└── scripts/
    └── README.md
```

The essence of installing a Skill is:

1. Create a directory that follows the Skill structure.
2. Copy or generate `SKILL.md`.
3. Copy optional references, templates, examples, and scripts.
4. Place the Skill directory in a location where the AI tool can discover it.
5. Validate naming, description, risk level, and safety behavior.

---

## 1. Separate global Skills and project Skills

Use different scopes for different types of Skills.

### Global Skills

Global Skills are reusable across many projects.

Recommended location:

```text
~/.claude/skills/<skill-name>/SKILL.md
```

Use global scope for:

* Learning workflows
* Concept explanation
* Prompt refinement
* Writing polish
* General task planning
* Skill creation or scaffolding

Examples:

```text
learn-concept-explain
learn-ai-roadmap
prompt-refine
writing-polish
skill-scaffold
```

### Project Skills

Project Skills are specific to a project, repository, product, or codebase.

Recommended location:

```text
.claude/skills/<skill-name>/SKILL.md
```

Use project scope for:

* Project-specific coding workflows
* Database migration review
* Release checks
* Architecture documentation updates
* Business-domain workflows
* Product workflows tied to the current project

Examples:

```text
code-safe-feature
code-bug-fix
db-migration-review
ops-release-check
doc-architecture-update
```

### Rule

Global Skills should be few, stable, and general.

Project Skills should be specific, contextual, and closer to the actual repository.

---

## 2. Use clear, searchable names

Skill names should make it easy for both humans and AI tools to locate the right Skill.

Use lowercase kebab-case.

Recommended format:

```text
<domain>-<action>-<object>
```

Examples:

```text
learn-concept-explain
learn-ai-roadmap
pm-prd-review
pm-feature-design
ux-prototype-review
code-safe-feature
code-bug-fix
code-review
db-migration-review
ops-release-check
doc-architecture-update
```

### Recommended domain prefixes

| Prefix  | Meaning                                         |
| ------- | ----------------------------------------------- |
| `learn` | Learning, concept explanation, study plans      |
| `pm`    | Product management, PRD, feature design         |
| `ux`    | UX review, prototype review, interaction design |
| `code`  | Coding, bug fixing, code review                 |
| `db`    | Database schema, migration, SQL review          |
| `ops`   | Deployment, release, environment checks         |
| `doc`   | Documentation, architecture, changelog          |
| `skill` | Skill creation, scaffolding, validation         |

### Avoid vague names

Avoid names like:

```text
review
helper
fix
assistant
workflow
agent
manager
```

These names are too broad and hard to locate.

### Good examples

```text
code-safe-feature
db-migration-review
pm-prd-review
learn-concept-explain
```

### Bad examples

```text
safe
reviewer
my-skill
coding-helper
ai-agent
```

---

## 3. Write descriptions for triggering, not marketing

The `description` field is one of the most important parts of a Skill.

It should help the AI decide:

1. What the Skill does.
2. When to use it.
3. When not to use it.
4. What keywords should trigger it.

### Description formula

Use this formula:

```text
What it does + when to use it + when not to use it + keywords
```

### Bad description

```yaml
description: Helps with code.
```

This is too vague.

### Good description

```yaml
description: Analyze a requested feature change before editing code. Use when adding or modifying features, APIs, pages, database fields, or workflows. Do not use for simple copywriting or one-line style changes. Keywords: new feature, API change, workflow change, before coding.
```

### Description checklist

A good description should be:

* Specific
* Action-oriented
* Clear about use cases
* Clear about non-use cases
* Searchable by keywords
* Not overly broad

---

## 4. Add quick positioning sections in every SKILL.md

Every `SKILL.md` should allow the AI and the user to quickly answer:

* What is this Skill for?
* When should it be used?
* When should it not be used?
* What inputs does it need?
* What output should it produce?

Recommended sections:

```md
# <skill-name>

## Purpose

## Best for

## Not for

## Required inputs

## Workflow

## Output format

## Safety rules
```

### Purpose

Explain the main goal of the Skill in one or two paragraphs.

### Best for

List scenarios where this Skill is useful.

### Not for

List scenarios where this Skill should not be used.

### Required inputs

List what the user should provide or what the AI should infer.

### Workflow

Define the step-by-step process.

### Output format

Define the expected output structure.

### Safety rules

Define what the Skill must not do without explicit confirmation.

---

## 5. Disable automatic invocation for high-risk Skills

Some Skills should not be triggered automatically.

High-risk Skills should normally require manual invocation.

High-risk domains usually include:

```text
code
db
ops
```

Examples:

```text
code-safe-feature
code-refactor-large
db-migration-review
db-schema-change
ops-release-check
ops-deploy
```

For high-risk Skills, add this to `SKILL.md` frontmatter:

```yaml
disable-model-invocation: true
```

This means the Skill should be manually invoked by the user, for example:

```text
/code-safe-feature
/db-migration-review
/ops-release-check
```

### When to disable automatic invocation

Use `disable-model-invocation: true` when the Skill may lead to:

* Code modification
* File deletion
* Database changes
* Deployment
* Environment changes
* Git operations
* Production risk
* Running scripts
* Accessing secrets

### Low-risk Skills may allow automatic invocation

Examples:

```text
learn-concept-explain
pm-prd-review
ux-prototype-review
writing-polish
```

These Skills usually only analyze, explain, or generate text.

---

## 6. Keep one Skill focused on one complete workflow

A Skill should handle one clear workflow.

Do not create a giant Skill that tries to do everything.

### Too broad

```text
ai-product-full-process
```

This is too large because it may include:

* Product definition
* PRD writing
* UX design
* Coding
* Testing
* Release
* Documentation

### Better split

```text
pm-feature-design
pm-prd-review
ux-prototype-review
code-safe-feature
code-review
ops-release-check
doc-changelog-update
```

### Rule

One Skill should complete one coherent task.

A good Skill output can become the input for the next Skill.

Example flow:

```text
pm-feature-design
→ pm-prd-review
→ code-safe-feature
→ code-review
→ ops-release-check
→ doc-changelog-update
```

---

## 7. Keep SKILL.md short and move details into supporting files

Do not put all knowledge into `SKILL.md`.

`SKILL.md` should be the entry point, not the entire knowledge base.

Use supporting files when needed:

```text
references/
templates/
examples/
scripts/
```

### references/

Use `references/` for detailed background, rules, policies, examples, architecture maps, risk files, or domain knowledge.

Examples:

```text
references/skill-best-practices.md
references/risk-files.md
references/module-map.md
references/db-change-rules.md
```

### templates/

Use `templates/` for reusable output formats.

Examples:

```text
templates/output-template.md
templates/review-report-template.md
templates/change-plan-template.md
```

### examples/

Use `examples/` for trigger examples, input examples, and output examples.

Examples:

```text
examples/trigger-examples.md
examples/sample-output.md
```

### scripts/

Use `scripts/` only for deterministic commands that are safer and more reliable as scripts.

Examples:

```text
scripts/validate-skill.sh
scripts/check-risk-files.sh
scripts/run-tests.sh
```

Do not create scripts by default.

---

## 8. Maintain a SKILLS_INDEX.md

A Skill library should include an index file to help humans quickly locate Skills.

For project-level Skills:

```text
.claude/SKILLS_INDEX.md
```

For global Skills:

```text
~/.claude/SKILLS_INDEX.md
```

Recommended table format:

```md
| Skill | Domain | Scope | Risk | Auto trigger | Purpose |
|---|---|---|---|---|---|
| code-safe-feature | code | project | high | No | Analyze feature changes before editing code |
| pm-prd-review | pm | project | medium | Yes | Review product requirement documents |
| learn-concept-explain | learn | global | low | Yes | Explain concepts in a structured way |
```

### Index rules

The index should be updated when:

* A new Skill is created
* A Skill is renamed
* A Skill is disabled
* A Skill changes risk level
* A Skill changes purpose
* A Skill is moved between global and project scope

The index should not replace good naming.

It is a navigation aid, not the main trigger mechanism.

---

## 9. Avoid unnecessary scripts

Scripts are powerful, but they increase risk.

Do not create a `scripts/` directory unless deterministic commands are needed.

### Good reasons to add scripts

* Validate Skill structure
* Run static checks
* Generate an index
* Run tests
* Format generated files
* Check for risky commands

### Bad reasons to add scripts

* To hide complex behavior
* To run destructive operations
* To deploy automatically
* To access secrets
* To upload files without review
* To replace clear instructions

### Risky commands

Any script should be reviewed for risky commands such as:

```text
rm -rf
curl
wget
ssh
scp
git push
git reset --hard
chmod 777
sudo
reading .env
reading ~/.ssh
uploading files
deleting files
changing production systems
```

If a script contains risky commands, the Skill should require explicit user confirmation.

High-risk Skills with scripts should usually include:

```yaml
disable-model-invocation: true
```

---

## 10. Manage Skill lifecycle

Not all Skills should remain active forever.

Use lifecycle directories or status labels to avoid clutter.

Recommended lifecycle structure:

```text
~/.claude/
├── skills/
├── skills-lab/
├── skills-disabled/
└── skills-archive/
```

### skills/

Stable Skills that are currently active.

### skills-lab/

Experimental Skills that are being tested.

These should not be installed into the active Skill directory unless needed.

### skills-disabled/

Skills that are temporarily disabled but may be reused later.

### skills-archive/

Old Skills kept for historical reference.

### Rule

Keep the active Skill directory small and useful.

Do not keep every experiment active.

---

## 11. Add CHANGELOG.md for mature or shared Skills

For important Skills, add a changelog.

Recommended location:

```text
<skill-name>/CHANGELOG.md
```

Use a changelog when:

* The Skill is shared with a team
* The Skill is open sourced
* The Skill changes behavior over time
* The Skill contains scripts
* The Skill is used in production-like workflows

Example:

```md
# Changelog

## 0.2.0

- Improved description trigger clarity
- Added high-risk safety rules
- Added output template

## 0.1.0

- Initial version
```

A changelog helps users understand why a Skill changed.

---

## 12. Validate every Skill after creation

Every Skill should be validated after creation or update.

### Required validation checklist

Check that:

* The Skill directory exists
* `SKILL.md` exists
* The Skill name uses lowercase kebab-case
* The frontmatter includes `name`
* The frontmatter includes `description`
* The description is specific
* The body includes required sections
* High-risk Skills include `disable-model-invocation: true`
* Unnecessary scripts are not created
* Existing scripts do not contain risky commands
* The Skill is listed in `SKILLS_INDEX.md`
* Trigger examples are included when useful

### Required sections checklist

`SKILL.md` should include:

```md
## Purpose
## Best for
## Not for
## Required inputs
## Workflow
## Output format
## Safety rules
```

### Risk validation

If the Skill domain is one of:

```text
code
db
ops
```

then check whether it should include:

```yaml
disable-model-invocation: true
```

### Script validation

If the Skill contains `scripts/`, review every script for risky commands.

---

## Recommended Skill creation flow

When creating a new Skill, follow this process.

### Step 1: Define the Skill

Collect or infer:

```text
scope: global or project
domain: learn / pm / ux / code / db / ops / doc / skill
name: action-object
risk: low / medium / high
purpose: one-sentence goal
```

### Step 2: Generate the final name

Use:

```text
<domain>-<action>-<object>
```

Example:

```text
domain: code
name: safe-feature
final skill name: code-safe-feature
```

### Step 3: Decide the target directory

For global scope:

```text
~/.claude/skills/<skill-name>/
```

For project scope:

```text
.claude/skills/<skill-name>/
```

### Step 4: Generate SKILL.md

Use the standard structure:

```md
---
name: <skill-name>
description: <specific trigger-oriented description>
disable-model-invocation: true
---

# <skill-name>

## Purpose

## Best for

## Not for

## Required inputs

## Workflow

## Output format

## Safety rules
```

Only include `disable-model-invocation: true` when needed.

### Step 5: Create supporting directories

Recommended default:

```text
references/
templates/
examples/
```

Do not create `scripts/` unless needed.

### Step 6: Update the index

Update:

```text
.claude/SKILLS_INDEX.md
```

or:

```text
~/.claude/SKILLS_INDEX.md
```

### Step 7: Validate

Run manual or scripted validation.

### Step 8: Provide a usage example

Example:

```text
/code-safe-feature

我要新增【视频上传】功能，先不要修改代码，先输出影响范围、风险和回归测试清单。
```

---

## Standard risk levels

### Low risk

The Skill only explains, summarizes, reviews, or generates text.

Examples:

```text
learn-concept-explain
learn-ai-roadmap
writing-polish
```

Default:

```text
automatic invocation allowed
```

### Medium risk

The Skill may influence product, design, or planning decisions but does not directly modify systems.

Examples:

```text
pm-prd-review
pm-feature-design
ux-prototype-review
doc-architecture-update
```

Default:

```text
automatic invocation usually allowed, but review output before action
```

### High risk

The Skill may lead to code changes, database changes, release actions, file deletion, environment modification, or script execution.

Examples:

```text
code-safe-feature
code-bug-fix
db-migration-review
ops-release-check
```

Default:

```yaml
disable-model-invocation: true
```

---

## Standard Skill directory template

Use this structure for most Skills:

```text
<skill-name>/
├── SKILL.md
├── references/
│   └── README.md
├── templates/
│   └── output-template.md
└── examples/
    └── trigger-examples.md
```

Use this structure only when scripts are required:

```text
<skill-name>/
├── SKILL.md
├── references/
│   └── README.md
├── templates/
│   └── output-template.md
├── examples/
│   └── trigger-examples.md
└── scripts/
    └── README.md
```

---

## Standard SKILL.md template

```md
---
name: <skill-name>
description: <what it does + when to use it + when not to use it + keywords>
---

# <skill-name>

## Purpose

Explain the purpose of this Skill.

## Best for

- Scenario 1
- Scenario 2
- Scenario 3

## Not for

- Scenario this Skill should not handle
- Another non-use case

## Required inputs

- Input 1
- Input 2

## Workflow

1. Understand the user's request.
2. Identify the relevant context.
3. Follow the task-specific process.
4. Produce the required output.
5. Ask for confirmation before high-risk actions.

## Output format

Return:

1. Summary
2. Key findings
3. Risks
4. Recommended next steps

## Safety rules

- Do not perform destructive actions without explicit confirmation.
- Do not create or run scripts unless required.
- Do not access secrets, `.env`, SSH keys, or production systems unless explicitly approved.
```

For high-risk Skills, use:

```md
---
name: <skill-name>
description: <what it does + when to use it + when not to use it + keywords>
disable-model-invocation: true
---
```

---

## Open source guidance

When creating Skills for an open source repository:

* Do not include private project names unless they are examples.
* Do not include secrets, tokens, credentials, or private URLs.
* Do not include company-only workflows unless they are generalized.
* Do not include local absolute paths from a private machine.
* Do not include personal server information.
* Keep examples generic.
* Use clear comments and safe defaults.
* Prefer MIT or another clear open source license for the repository.

---

## Summary

A good Skill should be:

* Easy to locate by name
* Easy to trigger by description
* Clear about when to use it
* Clear about when not to use it
* Focused on one complete workflow
* Safe by default
* Short in `SKILL.md`
* Extended through references, templates, and examples
* Validated after creation
* Indexed for human navigation

The goal of `skill-scaffold` is to make these practices automatic instead of relying on memory.
