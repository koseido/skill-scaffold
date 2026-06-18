---
name: {{skill_name}}
description: {{description}}
{{disable_model_invocation}}
---

# {{skill_name}}

## Purpose

{{purpose}}

This Skill should help the user complete one clear and reusable workflow.

It should not try to solve multiple unrelated tasks in one Skill.

## Best for

Use this Skill when the user wants to:

* {{best_for_1}}
* {{best_for_2}}
* {{best_for_3}}

Additional suitable scenarios:

* The task is repeated often enough to justify a reusable workflow.
* The task benefits from a standard process, checklist, or output format.
* The task has clear inputs, steps, and expected outputs.

## Not for

Do not use this Skill for:

* {{not_for_1}}
* {{not_for_2}}
* One-off tasks that are unlikely to be reused.
* Tasks that should be handled by a different, more specific Skill.
* Tasks that require immediate destructive actions without user confirmation.

## Required inputs

Before using this Skill, collect or infer:

* {{input_1}}
* {{input_2}}
* Target scope or module, if relevant.
* Expected output format, if relevant.
* Any safety constraints or user approvals required.

If required information is missing, make a reasonable assumption when safe.

Ask a clarifying question only when the missing information would materially change the result or create risk.

## Workflow

Follow this process:

1. Understand the user's request.
2. Identify whether this Skill is the right fit.
3. Confirm the task goal and expected output.
4. Identify relevant files, documents, modules, or context.
5. Apply the task-specific method.
6. Check risks, edge cases, or missing assumptions.
7. Produce the required output.
8. For high-risk actions, ask for explicit confirmation before making changes.
9. Summarize what was done and what should happen next.

## Output format

Return the result using this structure:

1. **Summary**

   * Briefly describe the result.

2. **Key findings**

   * List the most important findings, decisions, or generated content.

3. **Risks or assumptions**

   * Mention any uncertainty, risk, missing context, or assumption.

4. **Recommended next steps**

   * Suggest the next practical action.

## Safety rules

* Do not perform destructive actions without explicit user confirmation.
* Do not delete files unless the user explicitly asks.
* Do not run deployment, database migration, or production commands unless explicitly approved.
* Do not access secrets, `.env`, SSH keys, tokens, credentials, or private infrastructure unless explicitly approved.
* Do not create or run scripts unless they are clearly necessary.
* If scripts are created, keep them deterministic, readable, and safe by default.
* If the Skill may affect code, databases, infrastructure, release processes, or git history, use manual invocation by default.

## Supporting files

Use supporting files when the Skill needs more structure.

Recommended supporting files:

```text
references/
templates/
examples/
```

Use `scripts/` only when deterministic commands are required.

Do not put long reference material directly into `SKILL.md`.

## Validation checklist

Before considering this Skill complete, check:

* [ ] Skill name uses lowercase kebab-case.
* [ ] `SKILL.md` includes frontmatter.
* [ ] Frontmatter includes `name`.
* [ ] Frontmatter includes a specific `description`.
* [ ] Description explains what the Skill does.
* [ ] Description explains when to use it.
* [ ] Description explains when not to use it.
* [ ] High-risk Skills include `disable-model-invocation: true`.
* [ ] Body includes `Purpose`.
* [ ] Body includes `Best for`.
* [ ] Body includes `Not for`.
* [ ] Body includes `Required inputs`.
* [ ] Body includes `Workflow`.
* [ ] Body includes `Output format`.
* [ ] Body includes `Safety rules`.
* [ ] Supporting files are used instead of making `SKILL.md` too long.
* [ ] No unnecessary scripts were created.
* [ ] Any scripts were checked for risky commands.
* [ ] The Skill is listed in `SKILLS_INDEX.md`, if an index exists.

## Example usage

```text
/{{skill_name}}

{{usage_example}}
```
