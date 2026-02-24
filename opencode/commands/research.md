---
description: Research deeply and report evidence-based findings.
---

Research first. Do not implement code unless the user explicitly asks to switch modes.

If provided, treat this as the research question:
$ARGUMENTS

## Method

1. Define the question, scope, and success criteria.
2. Gather evidence from the codebase using `glob`, `grep`, and `read`.
3. Gather external evidence with `webfetch` when needed.
4. Distinguish observed facts from inference.
5. Synthesize a direct answer, supporting evidence, and open questions.

## Using subagents

Use `task` when parallel exploration will materially improve the result:

- `subagent_type: "explore"` for codebase discovery (`quick`, `medium`, or `very thorough` as needed)
- `subagent_type: "general"` for broad synthesis or multi-angle analysis

Give each subagent enough context to work independently and merge outputs into one coherent answer.

## Output expectations

- Be concise but complete.
- Cite concrete file paths and line references for repository claims.
- Cite sources for web claims.
- Call out uncertainty explicitly.
