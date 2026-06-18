# Installation

This document explains how to install `skill-scaffold`, how to install it into a project, and how to use the same standard when installing third-party Skills from GitHub.

---

## 1. What gets installed

The installable management Skill is located at:

```text
skills/skill-scaffold/
```

It contains:

```text
skills/skill-scaffold/
|- SKILL.md
|- references/
|- templates/
`- examples/
```

Installing `skill-scaffold` means copying this directory into a place where your AI tool can discover it.

It is not the same as:

```text
npm install
pip install
brew install
```

It is closer to placing a structured workflow package in a discoverable Skill directory.

---

## 2. Global installation

Use global installation if you want `skill-scaffold` available across all projects.

Recommended target:

```text
~/.claude/skills/skill-scaffold/
```

### Bash / Unix-like

From the repository root:

```bash
mkdir -p ~/.claude/skills
cp -R skills/skill-scaffold ~/.claude/skills/
```

### Windows PowerShell

```powershell
New-Item -ItemType Directory -Force -Path "$HOME/.claude/skills"
Copy-Item -Recurse -Path "skills/skill-scaffold" -Destination "$HOME/.claude/skills/"
```

### Verify

Check:

```bash
ls ~/.claude/skills/skill-scaffold
```

Expected result:

```text
SKILL.md
references
templates
examples
```

After that, in Claude Code you can use:

```text
/skill-scaffold
```

---

## 3. Project installation

Use project installation if you only want `skill-scaffold` available in a specific repository.

Recommended target:

```text
.claude/skills/skill-scaffold/
```

### Bash / Unix-like

From the repository root where `skill-scaffold` was cloned:

```bash
mkdir -p /path/to/your-project/.claude/skills
cp -R skills/skill-scaffold /path/to/your-project/.claude/skills/
```

Or from inside your project:

```bash
mkdir -p .claude/skills
cp -R /path/to/skill-scaffold/skills/skill-scaffold .claude/skills/
```

### Windows PowerShell

```powershell
New-Item -ItemType Directory -Force -Path "C:\path\to\your-project\.claude\skills"
Copy-Item -Recurse -Path "C:\path\to\skill-scaffold\skills\skill-scaffold" -Destination "C:\path\to\your-project\.claude\skills\"
```

---

## 4. Install with scripts

This repository includes both bash and PowerShell installers.

### Bash / Unix-like

```bash
chmod +x scripts/install-skill.sh
./scripts/install-skill.sh --scope global
./scripts/install-skill.sh --scope project --target /path/to/your-project
```

### Windows PowerShell

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install-skill.ps1 -Scope global
powershell -ExecutionPolicy Bypass -File scripts/install-skill.ps1 -Scope project -Target C:\path\to\your-project
```

These scripts only copy Skill directories and create a backup when overwrite mode is explicitly requested.

---

## 5. Recommended installation strategy

Use this strategy:

```text
Global:
~/.claude/skills/skill-scaffold/

Project:
your-project/.claude/skills/<project-specific-skill>/
```

Why:

- `skill-scaffold` is a general management Skill
- most business or code Skills should be project-specific
- global Skill directories should stay small and stable

---

## 6. First usage after installation

After installation, open Claude Code or another supported AI tool and use `skill-scaffold` as the management entry point.

Example:

```text
/skill-scaffold

I want to create a project-level Skill.
- domain: code
- name: safe-feature
- risk: high
- purpose: Analyze a feature change before editing code.

Do not create files yet.
First output the creation plan.
```

Expected behavior:

1. It proposes the final Skill name
2. It identifies the target directory
3. It determines the risk level
4. It recommends `disable-model-invocation: true` for high-risk Skills
5. It lists files to create or modify
6. It waits for confirmation before creating files

---

## 7. Creating a new Skill with the standard flow

Recommended flow:

### Step 1: Ask for a plan

```text
/skill-scaffold

I want to create a project-level Skill.
- domain: pm
- name: prd-review
- risk: medium
- purpose: Review product requirement documents for goals, user scenarios, workflows, edge cases, acceptance criteria, and implementation risks.

Do not create files yet.
First output the creation plan.
```

### Step 2: Confirm creation

```text
Confirmed. Please create the files according to the plan and update .claude/SKILLS_INDEX.md.
```

### Step 3: Review the generated result

Expected structure:

```text
.claude/skills/pm-prd-review/
|- SKILL.md
|- references/
|- templates/
`- examples/
```

---

## 8. Installing a third-party Skill from GitHub

Use this flow when you want to install an existing Skill from GitHub while still following the `skill-scaffold` standard.

### Step 1: Clone the source repository

Example:

```bash
git clone https://github.com/example/some-skills-repo.git
cd some-skills-repo
```

Windows PowerShell:

```powershell
git clone https://github.com/example/some-skills-repo.git
Set-Location some-skills-repo
```

### Step 2: Identify the Skill directory

Look for a directory that contains `SKILL.md`, for example:

```text
some-skills-repo/
`- skills/
   `- code-review/
      |- SKILL.md
      |- references/
      |- templates/
      `- examples/
```

### Step 3: Review before installing

Do not install a third-party Skill blindly.

Review:

- `SKILL.md`
- `references/`
- `templates/`
- `examples/`
- `scripts/`

Use the checklist in [docs/THIRD_PARTY_SKILL_REVIEW.md](</C:/00.work/04.code/skill-scaffold/docs/THIRD_PARTY_SKILL_REVIEW.md>).

At minimum, confirm:

- the Skill name is clear
- the description is specific
- high-risk behavior is constrained
- scripts do not contain risky commands
- the Skill belongs in `global`, `project`, or `lab`

### Step 4: Decide the target scope

Use `global` when the Skill is general and reusable across many projects.

Use `project` when the Skill is tied to a specific codebase or workflow.

Use `lab` first when the Skill is useful but not yet trusted enough for an active directory.

### Step 5: Install with the script using `--source`

Global install:

```bash
./scripts/install-skill.sh \
  --source /path/to/some-skills-repo/skills/code-review \
  --scope global
```

Project install:

```bash
./scripts/install-skill.sh \
  --source /path/to/some-skills-repo/skills/code-review \
  --scope project \
  --target /path/to/your-project
```

Windows PowerShell global install:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install-skill.ps1 `
  -Source C:\path\to\some-skills-repo\skills\code-review `
  -Scope global
```

Windows PowerShell project install:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install-skill.ps1 `
  -Source C:\path\to\some-skills-repo\skills\code-review `
  -Scope project `
  -Target C:\path\to\your-project
```

If the target Skill already exists, review the existing copy first.

Only use overwrite mode after you are sure you want to replace it:

```bash
./scripts/install-skill.sh --source /path/to/skill --scope project --target /path/to/project --force
```

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install-skill.ps1 -Source C:\path\to\skill -Scope project -Target C:\path\to\project -Force
```

### Step 6: Generate or update the index

After installation, update `SKILLS_INDEX.md`.

Project Skills:

```bash
./scripts/generate-skills-index.sh /path/to/your-project/.claude/skills
```

```powershell
powershell -ExecutionPolicy Bypass -File scripts/generate-skills-index.ps1 C:\path\to\your-project\.claude\skills
```

Global Skills:

```bash
./scripts/generate-skills-index.sh ~/.claude/skills
```

```powershell
powershell -ExecutionPolicy Bypass -File scripts/generate-skills-index.ps1 "$HOME/.claude/skills"
```

### Step 7: Validate after installation

Run validation to confirm the Skill and index both follow the standard.

```bash
./scripts/validate-skill.sh /path/to/your-project/.claude/skills
```

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-skill.ps1 C:\path\to\your-project\.claude\skills
```

### Recommended summary

Use this sequence:

```text
clone
-> inspect
-> review
-> choose scope
-> install with --source
-> generate or update SKILLS_INDEX.md
-> validate
```

---

## 9. Validation

Use the validation scripts after creating, installing, or updating Skills.

### Bash / Unix-like

Project Skills:

```bash
chmod +x scripts/validate-skill.sh
./scripts/validate-skill.sh .claude/skills
```

Global Skills:

```bash
./scripts/validate-skill.sh ~/.claude/skills
```

### Windows PowerShell

Project Skills:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-skill.ps1 .claude/skills
```

Global Skills:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-skill.ps1 "$HOME/.claude/skills"
```

Validation should check:

- Skill directory exists
- `SKILL.md` exists
- `name` exists
- `description` exists
- naming uses kebab-case
- high-risk Skills disable automatic invocation
- required sections exist
- scripts are not risky
- `SKILLS_INDEX.md` matches the required format and current Skills

---

## 10. Generating SKILLS_INDEX.md

If your Skill collection does not yet have an index, generate one with:

### Bash / Unix-like

Project Skills:

```bash
./scripts/generate-skills-index.sh .claude/skills
```

Global Skills:

```bash
./scripts/generate-skills-index.sh ~/.claude/skills
```

### Windows PowerShell

```powershell
powershell -ExecutionPolicy Bypass -File scripts/generate-skills-index.ps1 .claude/skills
powershell -ExecutionPolicy Bypass -File scripts/generate-skills-index.ps1 "$HOME/.claude/skills"
```

By default, the generator writes `SKILLS_INDEX.md` next to the Skills directory using the format defined in `docs/SKILLS_INDEX_SPEC.md`.

---

## 11. Updating skill-scaffold

If you want to update your installed copy of `skill-scaffold`, prefer a backup-and-replace flow instead of destructive deletion.

### Bash / Unix-like

```bash
cp -R ~/.claude/skills/skill-scaffold ~/.claude/skills/skill-scaffold.backup
cp -R skills/skill-scaffold ~/.claude/skills/
```

### Windows PowerShell

```powershell
Copy-Item -Recurse -Path "$HOME/.claude/skills/skill-scaffold" -Destination "$HOME/.claude/skills/skill-scaffold.backup"
Copy-Item -Recurse -Path "skills/skill-scaffold" -Destination "$HOME/.claude/skills/"
```

If you customized your installed copy, inspect the differences before replacing it.

---

## 12. Uninstall

Global uninstall:

```bash
rm -rf ~/.claude/skills/skill-scaffold
```

Project uninstall:

```bash
rm -rf .claude/skills/skill-scaffold
```

Windows PowerShell:

```powershell
Remove-Item -Recurse -Force "$HOME/.claude/skills/skill-scaffold"
Remove-Item -Recurse -Force ".claude/skills/skill-scaffold"
```

Use caution with deletion commands.

---

## 13. Troubleshooting

### Skill does not show up

Check that the path is correct:

```text
~/.claude/skills/skill-scaffold/SKILL.md
```

or:

```text
.claude/skills/skill-scaffold/SKILL.md
```

Restart your AI tool if needed.

### Skill exists but does not trigger automatically

`skill-scaffold` is intentionally designed for manual invocation.

It should include:

```yaml
disable-model-invocation: true
```

Use:

```text
/skill-scaffold
```

### New Skills are too broad

Check:

- name is specific
- description includes when not to use it
- workflow is focused on one complete task

### High-risk Skill triggers too easily

Add:

```yaml
disable-model-invocation: true
```

and use manual invocation.

---

## 14. Safety notes

Do not install third-party Skills blindly.

Before installing any external Skill, inspect:

```text
SKILL.md
references/
templates/
examples/
scripts/
```

Pay special attention to scripts.

Watch for:

```text
rm -rf
curl
wget
ssh
scp
git push
git reset --hard
sudo
.env
~/.ssh
```

Do not install Skills that read secrets, upload files, modify production systems, or hide risky behavior.
