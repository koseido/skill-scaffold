# Skill Specification

This document defines the structure, naming rules, safety rules, and validation requirements for Skills created with `skill-scaffold`.

It is intended for:

- Claude Code
- Codex
- VSCode AI IDEs
- Other AI coding assistants that can read and create files

The goal is to make Skill creation consistent, safe, easy to locate, and easy to maintain.

---

## 1. What is a Skill?

A Skill is a structured, reusable workflow package for an AI assistant.

A Skill is not a traditional software dependency.

A Skill is closer to:

```text
Reusable instructions + metadata + optional references + optional templates + optional scripts
```

At minimum, a Skill contains:

```text
<skill-name>/
└── SKILL.md
```

A recommended Skill contains:

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

A Skill should include `scripts/` only when deterministic commands are needed:

```text
<skill-name>/
├── SKILL.md
├── references/
├── templates/
├── examples/
└── scripts/
    └── README.md
```

---

## 2. Installation essence

Installing a Skill means placing a standard Skill directory in a location where the AI tool can discover it.

Installation usually includes:

1. Create the Skill directory.
2. Create or copy `SKILL.md`.
3. Add optional `references/`, `templates/`, `examples/`, or `scripts/`.
4. Register or document the Skill in `SKILLS_INDEX.md`.
5. Validate name, description, risk level, and safety behavior.

It is not equivalent to:

```text
npm install
pip install
brew install
```

It is closer to copying a structured workflow package into the right directory.

---

## 3. Scope rules

There are two main scopes.

### 3.1 Global Skills

Use global scope for reusable Skills that can apply across projects.

Recommended location:

```text
~/.claude/skills/<skill-name>/SKILL.md
```

Good global Skills:

```text
skill-scaffold
learn-concept-explain
learn-ai-roadmap
prompt-refine
writing-polish
task-planning
```

Global Skills should be few, stable, and general.

### 3.2 Project Skills

Use project scope for Skills tied to a specific repository, product, domain, or codebase.

Recommended location:

```text
.claude/skills/<skill-name>/SKILL.md
```

Good project Skills:

```text
code-safe-feature
code-bug-fix
code-review
db-migration-review
ops-release-check
doc-architecture-update
```

Project Skills can reference project-specific files such as:

```text
AGENTS.md
CLAUDE.md
docs/AI_CODEMAP.md
docs/RISK_FILES.md
docs/ARCHITECTURE.md
```

---

## 4. Naming rules

Skill names must be easy for both humans and AI tools to locate.

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
skill-scaffold
```

### 4.1 Recommended domain prefixes

| Prefix | Meaning |
|---|---|
| `learn` | Learning, concepts, study plans |
| `pm` | Product management, PRD, feature design |
| `ux` | UX review, prototype review, interaction design |
| `code` | Coding, bug fixing, code review |
| `db` | Database schema, SQL, migration review |
| `ops` | Release, deployment, environment checks |
| `doc` | Documentation, architecture, changelog |
| `skill` | Skill creation, scaffolding, validation |

### 4.2 Avoid vague names

Avoid:

```text
review
helper
fix
assistant
workflow
agent
manager
```

These are too broad.

Prefer:

```text
pm-prd-review
code-bug-fix
db-migration-review
ops-release-check
```

---

## 5. SKILL.md frontmatter

Every `SKILL.md` must include frontmatter.

Minimum required frontmatter:

```yaml
---
name: <skill-name>
description: <specific trigger-oriented description>
---
```

High-risk Skills should include:

```yaml
disable-model-invocation: true
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

## 6. Description rules

The `description` field should be written for triggering and positioning, not marketing.

Use this formula:

```text
What it does + when to use it + when not to use it + keywords
```

Bad:

```yaml
description: Helps with code.
```

Good:

```yaml
description: Analyze a requested feature change before editing code. Use when adding or modifying features, APIs, pages, database fields, or workflows. Do not use for simple copywriting or one-line style changes. Keywords: new feature, API change, workflow change, before coding.
```

A good description should be:

- Specific
- Action-oriented
- Clear about use cases
- Clear about non-use cases
- Searchable by keywords
- Not overly broad

---

## 7. Required SKILL.md sections

Every generated Skill should include these sections:

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

Explain what the Skill is for.

### Best for

List the scenarios where this Skill should be used.

### Not for

List cases where this Skill should not be used.

### Required inputs

List what the user should provide or what the AI should infer.

### Workflow

Define the step-by-step process.

### Output format

Define the expected response structure.

### Safety rules

Define the safety limits and confirmation requirements.

---

## 8. Risk levels

Each Skill should have a risk level.

### 8.1 Low risk

The Skill only explains, summarizes, reviews, or generates text.

Examples:

```text
learn-concept-explain
learn-ai-roadmap
writing-polish
```

Default behavior:

```text
Automatic invocation can be allowed.
```

### 8.2 Medium risk

The Skill may influence product, design, or documentation decisions but does not directly modify systems.

Examples:

```text
pm-prd-review
pm-feature-design
ux-prototype-review
doc-architecture-update
skill-scaffold
```

Default behavior:

```text
Automatic invocation may be allowed, but output should be reviewed before action.
```

### 8.3 High risk

The Skill may lead to code changes, database changes, release actions, file deletion, environment changes, git operations, or script execution.

Examples:

```text
code-safe-feature
code-bug-fix
db-migration-review
ops-release-check
```

Default behavior:

```yaml
disable-model-invocation: true
```

---

## 9. Automatic invocation rules

High-risk Skills should usually require manual invocation.

Use:

```yaml
disable-model-invocation: true
```

when the Skill may involve:

- Code modification
- File deletion
- Database changes
- Deployment
- Environment changes
- Git operations
- Running scripts
- Accessing secrets
- Production risk

Manual invocation examples:

```text
/code-safe-feature
/db-migration-review
/ops-release-check
```

---

## 10. Supporting file rules

Do not put all content into `SKILL.md`.

Use supporting files to keep `SKILL.md` focused.

### references/

Use for detailed rules, domain knowledge, checklists, architecture maps, risk files, and background material.

Examples:

```text
references/risk-files.md
references/module-map.md
references/db-change-rules.md
references/skill-best-practices.md
```

### templates/

Use for reusable output formats.

Examples:

```text
templates/output-template.md
templates/change-plan-template.md
templates/review-report-template.md
```

### examples/

Use for trigger examples, sample inputs, and sample outputs.

Examples:

```text
examples/trigger-examples.md
examples/sample-output.md
```

### scripts/

Use only when deterministic commands are necessary.

Examples:

```text
scripts/validate-skill.sh
scripts/check-risk-files.sh
scripts/run-tests.sh
```

Do not create scripts by default.

---

## 11. Script safety rules

Scripts are powerful and risky.

Only add scripts when they are necessary.

Review scripts for risky commands:

```text
rm -rf
curl
wget
ssh
scp
git push
git reset --hard
sudo
chmod 777
.env
~/.ssh
uploading files
deleting files
changing production systems
```

If a Skill contains risky scripts, it should include:

```yaml
disable-model-invocation: true
```

and should require explicit user confirmation before running them.

---

## 12. SKILLS_INDEX.md

A Skill collection should include an index for human navigation.

Project index:

```text
.claude/SKILLS_INDEX.md
```

Global index:

```text
~/.claude/SKILLS_INDEX.md
```

Recommended format:

```md
| Skill | Domain | Scope | Risk | Auto trigger | Purpose |
|---|---|---|---|---|---|
| code-safe-feature | code | project | high | No | Analyze feature changes before editing code |
| pm-prd-review | pm | project | medium | Yes | Review product requirement documents |
| learn-concept-explain | learn | global | low | Yes | Explain concepts in a structured way |
```

The index should be updated when:

- A Skill is created
- A Skill is renamed
- A Skill is disabled
- A Skill changes risk level
- A Skill changes purpose
- A Skill is moved between scopes

---

## 13. Lifecycle management

Use lifecycle directories or status labels to avoid clutter.

Recommended structure:

```text
~/.claude/
├── skills/
├── skills-lab/
├── skills-disabled/
└── skills-archive/
```

### skills/

Stable active Skills.

### skills-lab/

Experimental Skills.

### skills-disabled/

Temporarily disabled Skills.

### skills-archive/

Historical or deprecated Skills.

Keep the active directory small and useful.

---

## 14. Changelog rules

For mature, shared, or open-source Skills, add:

```text
<skill-name>/CHANGELOG.md
```

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

Use a changelog when:

- The Skill is open sourced
- The Skill is used by a team
- The Skill contains scripts
- The Skill changes behavior over time

---

## 15. Validation checklist

Every Skill should be validated after creation or update.

Check:

- [ ] Skill directory exists
- [ ] `SKILL.md` exists
- [ ] Skill name uses lowercase kebab-case
- [ ] Frontmatter includes `name`
- [ ] Frontmatter includes `description`
- [ ] Description is specific
- [ ] Description includes when to use it
- [ ] Description includes when not to use it
- [ ] Body includes `Purpose`
- [ ] Body includes `Best for`
- [ ] Body includes `Not for`
- [ ] Body includes `Required inputs`
- [ ] Body includes `Workflow`
- [ ] Body includes `Output format`
- [ ] Body includes `Safety rules`
- [ ] High-risk Skills include `disable-model-invocation: true`
- [ ] No unnecessary scripts were created
- [ ] Scripts do not contain risky commands
- [ ] `SKILLS_INDEX.md` is updated

---

## 16. Standard creation flow

When creating a Skill, follow this flow:

### Step 1: Plan

Before editing files, output:

1. Final Skill name
2. Scope
3. Domain
4. Risk level
5. Target directory
6. Files to create
7. Whether automatic invocation should be disabled
8. Whether scripts are needed

### Step 2: Create

After confirmation, create:

```text
<target-skill-dir>/SKILL.md
<target-skill-dir>/references/README.md
<target-skill-dir>/templates/output-template.md
<target-skill-dir>/examples/trigger-examples.md
```

Create `scripts/` only when needed.

### Step 3: Register

Update:

```text
SKILLS_INDEX.md
```

### Step 4: Validate

Run the validation checklist.

### Step 5: Provide usage example

Example:

```text
/code-safe-feature

我要新增【视频上传】功能，先不要修改代码，先输出影响范围、风险和回归测试清单。
```

---

## 17. Open-source safety

When preparing a Skill for open source:

- Do not include secrets or credentials.
- Do not include `.env`.
- Do not include SSH keys.
- Do not include private server IPs.
- Do not include personal local paths.
- Do not include company-only workflows unless generalized.
- Do not include private screenshots or internal documents.
- Use safe defaults.
- Add a license.
- Add a README.
- Add contribution guidelines if accepting contributions.

---

## Summary

A good Skill is:

- Easy to locate by name
- Easy to trigger by description
- Focused on one complete workflow
- Safe by default
- Short in `SKILL.md`
- Extended by references, templates, and examples
- Validated after creation
- Indexed for human navigation

The goal of `skill-scaffold` is to make these practices automatic.
