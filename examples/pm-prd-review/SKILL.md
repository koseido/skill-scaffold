---
name: pm-prd-review
description: Review product requirement documents for goals, user scenarios, workflows, edge cases, acceptance criteria, implementation risks, and AI product quality. Use when checking PRDs, feature specs, product plans, or requirement drafts. Do not use for coding, deployment, database migration, or visual UI generation. Keywords: PRD review, product requirement, feature spec, acceptance criteria, user story.
---

# pm-prd-review

## Purpose

Use this Skill to review a product requirement document or feature specification.

The goal is to help the user identify unclear goals, missing user scenarios, weak business logic, edge cases, acceptance criteria gaps, implementation risks, and improvement opportunities.

This Skill is especially useful for product managers who want to improve requirement quality before design, development, or stakeholder review.

## Best for

Use this Skill when the user wants to:

- Review a PRD
- Improve a feature requirement
- Check product logic
- Identify missing scenarios
- Validate acceptance criteria
- Prepare requirements for engineering
- Review AI product features
- Compare a requirement against product goals
- Turn rough notes into a more complete requirement review

Good example requests:

```text
帮我评审这个 PRD，看哪里不清楚。
```

```text
这个 AI 功能需求是否完整？从资深产品经理角度帮我检查。
```

```text
帮我检查这个功能有没有遗漏边界条件和验收标准。
```

## Not for

Do not use this Skill for:

- Writing production code
- Fixing bugs
- Running tests
- Database schema changes
- Deployment or release checks
- Visual prototype generation
- Pure copywriting polish
- Interview evaluation

Use a different Skill when appropriate:

```text
pm-feature-design
ux-prototype-review
code-safe-feature
code-review
ops-release-check
```

## Required inputs

Collect or infer:

- Product background
- Target users
- Problem statement
- Feature goal
- User scenarios
- User flow or business flow
- Functional requirements
- Non-functional requirements
- Acceptance criteria
- Constraints
- Metrics or success indicators
- Known risks or dependencies

If the user provides only partial requirements, review what is available and clearly list missing information.

Do not block the review unless the missing information makes the review impossible.

## Review dimensions

Review the PRD using these dimensions:

### 1. Goal clarity

Check:

- Is the problem clear?
- Is the target user clear?
- Is the expected outcome clear?
- Is the business value clear?
- Is the success metric clear?

### 2. User scenario completeness

Check:

- Main scenario
- Secondary scenarios
- Empty states
- Error states
- Permission differences
- New user vs existing user
- Edge cases
- Cross-device or cross-platform cases

### 3. Workflow logic

Check:

- Entry point
- Main path
- Branch paths
- Exit path
- Failure path
- Retry path
- State changes
- Data dependencies

### 4. Requirement completeness

Check whether requirements include:

- Functional requirements
- Data requirements
- Permission rules
- Notification rules
- Configuration rules
- Compatibility requirements
- Performance requirements
- Logging or tracking requirements

### 5. Acceptance criteria

Check whether acceptance criteria are:

- Testable
- Specific
- Complete
- Connected to user scenarios
- Clear enough for engineering and QA

### 6. Implementation risks

Identify risks related to:

- System complexity
- Data model changes
- API dependency
- Third-party dependency
- Performance
- Security
- Compliance
- Compatibility
- Rollback
- Operational cost

### 7. AI product quality, if applicable

For AI features, also check:

- User input clarity
- Prompt or instruction quality
- Model output uncertainty
- Failure handling
- Human review requirement
- Explainability
- Data privacy
- Cost and latency
- Evaluation criteria
- Feedback loop

## Workflow

1. Read the provided PRD or requirement draft.
2. Summarize the feature in plain language.
3. Identify the intended user and goal.
4. Review the requirement using the review dimensions.
5. Separate critical issues from improvement suggestions.
6. Identify missing information.
7. Provide revised requirement suggestions when useful.
8. Produce an actionable review report.

## Output format

Return:

```md
## PRD Review

### 1. Requirement summary

### 2. Overall judgment

Clear / Partially clear / Not clear

### 3. Major issues

| Severity | Issue | Why it matters | Suggested fix |
|---|---|---|---|

### 4. Missing scenarios

### 5. Logic gaps

### 6. Acceptance criteria suggestions

### 7. Implementation risks

### 8. AI-specific risks, if applicable

### 9. Suggested improvements

### 10. Final recommendation

Ready for development / Needs revision / Needs major rewrite
```

## Severity definitions

Use three severity levels:

### High

The issue may cause wrong product direction, development misunderstanding, data risk, or failed delivery.

### Medium

The issue may cause rework, unclear implementation, or incomplete user experience.

### Low

The issue is an improvement suggestion, wording issue, or minor detail.

## Safety rules

- Do not invent business facts.
- Do not assume technical feasibility without evidence.
- Do not turn review into code implementation.
- Do not overcomplicate a simple requirement.
- Clearly separate facts, assumptions, and suggestions.
- If the requirement is incomplete, review available content and list missing parts.
- If the feature is AI-related, mention uncertainty, evaluation, privacy, and failure handling.

## Example usage

```text
/pm-prd-review

请从资深 AI 产品经理角度评审下面这个 PRD，重点看：
1. 目标是否清晰
2. 用户场景是否完整
3. 业务流程是否闭环
4. 边界条件是否遗漏
5. 验收标准是否可测试
6. 开发风险在哪里
```
