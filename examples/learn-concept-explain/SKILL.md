---
name: learn-concept-explain
description: Explain AI, product, or technical concepts in a structured and beginner-friendly way. Use when the user asks what a concept means, how it works, why it matters, how to apply it, or what common misunderstandings exist. Do not use for coding changes, deployment, PRD review, or database migration. Keywords: explain concept, what is, how it works, AI learning, LLM, RAG, Agent, MCP.
---

# learn-concept-explain

## Purpose

Use this Skill to explain AI, product, or technical concepts clearly and practically.

The goal is not only to define a concept, but to help the user understand:

1. What it is
2. Why it matters
3. How it works
4. How to apply it
5. What mistakes to avoid

This Skill is especially useful for AI learning, product manager learning, and technical concept building.

## Best for

Use this Skill when the user asks:

- What does this concept mean?
- How does this technology work?
- Why is this important?
- How should a product manager understand it?
- How can it be applied in a real product?
- What are common misunderstandings?
- How is this different from another concept?
- What should I learn next?

Good example requests:

```text
RAG 是什么？产品经理应该怎么理解？
```

```text
LLM 原理是什么？不要太学术，用产品经理能理解的方式解释。
```

```text
Agent 和 Workflow 有什么区别？
```

```text
MCP 是什么？能解决什么问题？
```

## Not for

Do not use this Skill for:

- Writing production code
- Fixing bugs
- Reviewing PRDs
- Designing UI prototypes
- Running scripts
- Deploying services
- Changing databases
- Making financial, medical, or legal decisions without up-to-date verification

Use another Skill when appropriate:

```text
pm-prd-review
pm-feature-design
code-safe-feature
db-migration-review
ops-release-check
```

## Required inputs

Collect or infer:

- The concept to explain
- User's current level, if provided
- Desired depth
- Desired angle, such as product, engineering, business, or learning
- Whether examples are needed
- Whether comparison with related concepts is needed

If the user does not specify depth, use a practical beginner-to-intermediate explanation.

## Explanation framework

Use this structure by default:

### 1. One-sentence definition

Explain the concept in one sentence.

### 2. Plain-language explanation

Explain it in simple language without unnecessary jargon.

### 3. Why it matters

Explain why the concept is important in real work.

### 4. How it works

Describe the basic mechanism or process.

### 5. Practical example

Use a concrete example, preferably related to AI products, software products, or the user's context.

### 6. Common misunderstandings

List what people often get wrong.

### 7. How to apply it

Explain how the user can use the concept in product, engineering, or learning.

### 8. What to learn next

Suggest the next related concepts or practice tasks.

## Workflow

1. Identify the concept.
2. Identify the user's likely goal.
3. Choose the right explanation depth.
4. Start with a simple definition.
5. Explain with examples.
6. Add product or engineering relevance.
7. Mention common misunderstandings.
8. Suggest next steps or practice tasks.
9. Avoid excessive jargon unless the user asks for depth.

## Output format

Return:

```md
## Concept: <concept>

### 1. One-sentence definition

### 2. Plain-language explanation

### 3. Why it matters

### 4. How it works

### 5. Practical example

### 6. Common misunderstandings

### 7. How to apply it

### 8. What to learn next
```

If the user asks for comparison, use:

```md
## Comparison: <A> vs <B>

| Dimension | A | B |
|---|---|---|

### Key takeaway
```

If the user asks for a learning plan, use:

```md
## Learning path

### Stage 1

### Stage 2

### Stage 3

### Practice task
```

## Style rules

- Use clear and direct language.
- Prefer concrete examples over abstract definitions.
- Avoid unexplained jargon.
- Use analogies only when they improve clarity.
- Do not oversimplify important limitations.
- Separate facts from assumptions.
- If the concept may have changed recently, recommend verifying with current documentation.

## Safety rules

- Do not provide high-stakes professional advice without appropriate caution.
- Do not pretend uncertain or fast-changing information is fixed.
- Do not recommend production implementation without context.
- Do not turn explanation into code modification unless the user explicitly asks.
- If the user asks about current tools, APIs, pricing, or regulations, verify with up-to-date sources when possible.

## Example usage

```text
/learn-concept-explain

RAG 是什么？
请按：
1. 是什么
2. 为什么重要
3. 怎么工作
4. 产品经理怎么用
5. 常见误区
来解释
```
