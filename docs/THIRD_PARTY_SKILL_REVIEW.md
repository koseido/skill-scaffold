# Third-Party Skill Review Checklist

Use this checklist before installing a Skill copied from GitHub, a shared folder, a teammate, or any other source you did not author yourself.

The goal is simple:

> Review first, normalize second, install third.

---

## 1. Review outcome categories

Use one of these judgments:

- `Pass`: safe to install as-is
- `Needs changes`: useful, but should be renamed, constrained, or restructured first
- `Lab only`: install only into an experimental directory
- `Do not install`: too risky, too unclear, or too environment-specific

---

## 2. Source review

Check:

- Where did this Skill come from?
- Is the source public, internal, or unknown?
- Is the repository or folder focused on Skills, or is the Skill buried inside unrelated files?
- Does the source include a license if you plan to reuse or publish it?

Flags:

- Unknown or unverifiable origin
- Mixed repository with unrelated deploy or infrastructure scripts
- No clear ownership or maintenance history

---

## 3. Naming review

Check:

- Does the directory use lowercase kebab-case?
- Does the name follow `<domain>-<action>-<object>` when possible?
- Is the name specific enough to be searchable?

Good examples:

```text
code-safe-feature
pm-prd-review
learn-concept-explain
```

Bad examples:

```text
helper
review
workflow
agent
```

Action:

- Rename vague Skills before installing them into an active directory.

---

## 4. Frontmatter review

Check `SKILL.md` frontmatter for:

- `name`
- `description`
- `disable-model-invocation: true` when needed

The `name` should match the directory.

The `description` should explain:

- What the Skill does
- When to use it
- When not to use it
- Keywords or trigger hints

Flags:

- Missing `name`
- Missing `description`
- Marketing language instead of trigger guidance
- High-risk Skill without `disable-model-invocation: true`

---

## 5. Structure review

Preferred structure:

```text
<skill-name>/
|- SKILL.md
|- references/
|- templates/
`- examples/
```

Optional:

```text
scripts/
```

Check:

- Is `SKILL.md` present?
- Are support files organized clearly?
- Is the structure flat and predictable?
- Is the Skill small enough to understand quickly?

Flags:

- Nested or confusing category folders
- Huge `SKILL.md` used as a dumping ground
- Unexplained files with unclear roles

---

## 6. Workflow review

Check whether the Skill is focused on one coherent workflow.

Good examples:

- review a PRD
- analyze a code feature change
- explain a concept

Bad examples:

- one Skill that does planning, coding, testing, deployment, and docs together

Flags:

- Broad multi-purpose agent behavior
- Unclear boundaries with other Skills
- Hidden workflow steps in scripts

Action:

- Split broad Skills before trusting them as active Skills.

---

## 7. Risk review

Decide whether the Skill is:

- `low`
- `medium`
- `high`

Typical risk defaults:

- `learn` -> low
- `pm`, `ux`, `doc`, `skill` -> medium
- `code`, `db`, `ops` -> high

Treat as high risk if the Skill may lead to:

- code changes
- database changes
- deploys
- environment changes
- file deletion
- git history changes
- production impact

Action:

- High-risk Skills should usually require manual invocation.

---

## 8. Script review

If the Skill contains `scripts/`, review every file.

Look for:

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
id_rsa
id_ed25519
upload
deploy
production
```

Questions:

- Is the script deterministic and reviewable?
- Does it only inspect or copy files?
- Does it hide behavior that should be in `SKILL.md`?
- Does it access secrets, infra, or remote services?

Action:

- If a script is risky or unclear, do not install into an active Skill directory.

---

## 9. Environment review

Check whether the Skill assumes:

- private file paths
- company-only URLs
- local usernames
- internal systems
- hidden environment variables
- internal architecture documents

Flags:

- hard-coded personal machine paths
- organization-only knowledge with no explanation
- private or production endpoints

Action:

- Normalize or remove environment-specific assumptions before reuse.

---

## 10. Placement decision

Choose one target:

- `~/.claude/skills/`
- `.claude/skills/`
- `skills-lab/`
- `skills-disabled/`
- `skills-archive/`

Use `global` when the Skill is:

- general
- low or medium risk
- reusable across many projects

Use `project` when the Skill is:

- codebase-specific
- tied to local docs or architecture
- high-context or high-risk

Use `lab` when the Skill is:

- untrusted
- experimental
- useful but not yet normalized

---

## 11. Normalization actions

Before installation, decide whether to:

- rename the Skill
- rewrite the description
- add `disable-model-invocation: true`
- move long details into `references/`
- add templates or examples
- remove or quarantine risky scripts
- update `SKILLS_INDEX.md`

If you only want review output, propose these changes without editing files.

---

## 12. Minimum pass checklist

A third-party Skill is usually safe enough to install when:

- The source is understood
- The directory name is clear
- `SKILL.md` exists
- Frontmatter is valid
- The description is specific
- Risk level is understood
- High-risk invocation is constrained
- Scripts are absent or reviewed
- No secrets or private infra are embedded
- The target placement is appropriate

---

## 13. Suggested review output

Use this format when reviewing a third-party Skill:

```md
## Third-party Skill review

### 1. Overall judgment

Pass / Needs changes / Lab only / Do not install

### 2. Source and trust notes

### 3. Naming and description issues

### 4. Risk and invocation review

### 5. Script and safety review

### 6. Structure review

### 7. Recommended target location

### 8. Required changes before installation
```
