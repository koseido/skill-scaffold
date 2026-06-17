# Installation

This document explains how to install `skill-scaffold` and how to use it to create new Skills.

---

## 1. What gets installed?

The installable Skill is located at:

```text
skills/skill-scaffold/
```

It contains:

```text
skills/skill-scaffold/
├── SKILL.md
├── references/
│   └── skill-best-practices.md
├── templates/
│   ├── SKILL.template.md
│   └── output-template.md
└── examples/
    └── trigger-examples.md
```

Installing means copying this directory into a place where your AI tool can discover it.

---

## 2. Global installation

Use global installation if you want `skill-scaffold` available across all projects.

Recommended target:

```text
~/.claude/skills/skill-scaffold/
```

### Manual install

From the repository root:

```bash
mkdir -p ~/.claude/skills
cp -R skills/skill-scaffold ~/.claude/skills/
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

In Claude Code, you can then use:

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

### Manual install

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

---

## 4. Install with script

If this repository includes `scripts/install-skill.sh`, you can install with:

```bash
chmod +x scripts/install-skill.sh
./scripts/install-skill.sh
```

A basic installer should copy:

```text
skills/skill-scaffold
```

to:

```text
~/.claude/skills/skill-scaffold
```

If the installer supports arguments, recommended usage is:

```bash
./scripts/install-skill.sh --scope global
./scripts/install-skill.sh --scope project --target /path/to/your-project
```

---

## 5. Recommended installation strategy

Use this strategy:

```text
Global:
~/.claude/skills/skill-scaffold/

Project:
your-project/.claude/skills/<project-specific-skill>/
```

Why?

- `skill-scaffold` is a general Skill creation tool.
- Most new Skills should be project-specific.
- Global Skills should stay few and stable.

---

## 6. First usage

After installation, open Claude Code in a project directory and run:

```text
/skill-scaffold

我要创建一个项目级 Skill：
- domain: code
- name: safe-feature
- risk: high
- purpose: 新增功能前做安全变更分析

先不要创建文件，先输出创建方案。
```

Expected behavior:

1. It proposes the final Skill name.
2. It identifies the target directory.
3. It decides the risk level.
4. It recommends `disable-model-invocation: true` for high-risk Skills.
5. It lists files to create.
6. It waits for confirmation before creating files.

---

## 7. Creating a new Skill

Recommended flow:

### Step 1: Ask for a plan

```text
/skill-scaffold

我要创建一个项目级 Skill：
- domain: pm
- name: prd-review
- risk: medium
- purpose: 评审产品需求文档，检查目标、用户场景、业务流程、边界条件、验收标准和实现风险

先不要创建文件，先输出创建方案。
```

### Step 2: Confirm creation

```text
确认，请按方案创建文件，并更新 .claude/SKILLS_INDEX.md。
```

### Step 3: Review result

Check the generated files:

```text
.claude/skills/pm-prd-review/
├── SKILL.md
├── references/
├── templates/
└── examples/
```

---

## 8. Validation

If this repository includes `scripts/validate-skill.sh`, run:

```bash
chmod +x scripts/validate-skill.sh
./scripts/validate-skill.sh .claude/skills
```

For global Skills:

```bash
./scripts/validate-skill.sh ~/.claude/skills
```

Validation should check:

- Skill directory exists
- `SKILL.md` exists
- `name` exists
- `description` exists
- Naming uses kebab-case
- High-risk Skills disable automatic invocation
- Required sections exist
- Scripts are not risky

---

## 9. Updating installation

To update `skill-scaffold`, replace the installed directory:

```bash
rm -rf ~/.claude/skills/skill-scaffold
cp -R skills/skill-scaffold ~/.claude/skills/
```

Use caution with `rm -rf`.

If you customized your local copy, back it up first:

```bash
cp -R ~/.claude/skills/skill-scaffold ~/.claude/skills/skill-scaffold.backup
```

---

## 10. Uninstall

Global uninstall:

```bash
rm -rf ~/.claude/skills/skill-scaffold
```

Project uninstall:

```bash
rm -rf .claude/skills/skill-scaffold
```

Use caution with deletion commands.

---

## 11. Troubleshooting

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

- Name is specific
- Description includes when not to use it
- Workflow is focused on one complete task

### High-risk Skill triggers too easily

Add:

```yaml
disable-model-invocation: true
```

and use manual invocation.

---

## 12. Safety notes

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
