# Skill Creation Result

## 1. Skill name

```text
{{skill_name}}
```

## 2. Scope

```text
{{scope}}
```

Allowed values:

```text
global
project
```

Global Skill target:

```text
~/.claude/skills/{{skill_name}}/
```

Project Skill target:

```text
.claude/skills/{{skill_name}}/
```

## 3. Domain

```text
{{domain}}
```

Recommended domains:

```text
learn
pm
ux
code
db
ops
doc
skill
```

## 4. Risk level

```text
{{risk_level}}
```

Allowed values:

```text
low
medium
high
```

Recommended defaults:

| Domain  | Default risk |
| ------- | ------------ |
| `learn` | low          |
| `pm`    | medium       |
| `ux`    | medium       |
| `code`  | high         |
| `db`    | high         |
| `ops`   | high         |
| `doc`   | medium       |
| `skill` | medium       |

## 5. Auto invocation setting

```text
{{auto_invocation}}
```

Use:

```yaml
disable-model-invocation: true
```

when the Skill is high risk or should only be manually invoked.

High-risk examples:

```text
code-safe-feature
code-bug-fix
db-migration-review
ops-release-check
```

## 6. Target directory

```text
{{target_directory}}
```

## 7. Files created or updated

```text
{{target_directory}}/
├── SKILL.md
├── references/
│   └── README.md
├── templates/
│   └── output-template.md
└── examples/
    └── trigger-examples.md
```

If scripts are needed:

```text
{{target_directory}}/
└── scripts/
    └── README.md
```

## 8. SKILL.md frontmatter

```yaml
---
name: {{skill_name}}
description: {{description}}
{{disable_model_invocation}}
---
```

## 9. Purpose

```text
{{purpose}}
```

## 10. Best for

This Skill is best for:

* {{best_for_1}}
* {{best_for_2}}
* {{best_for_3}}

## 11. Not for

This Skill should not be used for:

* {{not_for_1}}
* {{not_for_2}}
* Tasks that are better handled by another specific Skill.
* Destructive or production-impacting actions without explicit confirmation.

## 12. Required inputs

The Skill should collect or infer:

* {{input_1}}
* {{input_2}}
* Scope or module, if relevant.
* Expected output format, if relevant.
* Safety constraints, if relevant.

## 13. Validation result

### Structure validation

* [ ] Skill directory exists.
* [ ] `SKILL.md` exists.
* [ ] `references/` exists.
* [ ] `templates/` exists.
* [ ] `examples/` exists.
* [ ] `scripts/` is only created when needed.

### Naming validation

* [ ] Skill name uses lowercase kebab-case.
* [ ] Skill name follows `<domain>-<action>-<object>` when appropriate.
* [ ] Skill name is specific enough to locate quickly.

### Description validation

* [ ] Description explains what the Skill does.
* [ ] Description explains when to use it.
* [ ] Description explains when not to use it.
* [ ] Description includes useful trigger keywords.
* [ ] Description is not overly broad.

### Risk validation

* [ ] Risk level is assigned.
* [ ] High-risk domains are reviewed carefully.
* [ ] High-risk Skills include `disable-model-invocation: true`.
* [ ] Dangerous actions require explicit confirmation.

### Script validation

* [ ] No unnecessary scripts were created.
* [ ] Scripts do not contain risky commands.
* [ ] Scripts do not access secrets.
* [ ] Scripts do not deploy, delete, upload, or modify production systems without approval.

Risky commands to check:

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
```

### Index validation

* [ ] `SKILLS_INDEX.md` exists or was created.
* [ ] The new Skill is listed in the index.
* [ ] The index includes domain, scope, risk, auto trigger, and purpose.

Recommended index format:

```md
| Skill | Domain | Scope | Risk | Auto trigger | Purpose |
|---|---|---|---|---|---|
| {{skill_name}} | {{domain}} | {{scope}} | {{risk_level}} | {{auto_trigger}} | {{purpose}} |
```

## 14. Usage example

```text
/{{skill_name}}

{{usage_example}}
```

## 15. Next steps

Recommended next actions:

1. Review the generated `SKILL.md`.
2. Add domain-specific details to `references/` if needed.
3. Adjust the output format in `templates/output-template.md`.
4. Add trigger examples in `examples/trigger-examples.md`.
5. Run validation manually or with `scripts/validate-skill.sh`.
6. Test the Skill with a real prompt.
