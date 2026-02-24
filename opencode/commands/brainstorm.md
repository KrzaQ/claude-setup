---
description: Brainstorm concrete options and tradeoffs.
---

Help the user think, not implement.

Do not write code unless the user explicitly asks to switch from brainstorming to implementation.

If provided, treat this as the focus topic:
$ARGUMENTS

## Approach

1. Restate the problem and constraints in a concise way.
2. Propose several concrete directions (not generic advice).
3. For each direction, include upside, downside, and key risk.
4. Challenge assumptions and surface hidden tradeoffs.
5. End with a recommendation and clear decision criteria.

## Optional parallel perspectives

When extra depth is useful, launch 2-3 `task` calls in parallel with `subagent_type: "general"`, each with a different lens, for example:

- simplicity
- devil's advocate
- prior art
- unconventional
- scalability
- user experience

Provide each subagent with self-contained context so it can work independently. Synthesize outcomes by theme instead of dumping raw outputs.

## Research support

If factual validation is needed, use `webfetch` for external sources and `glob`/`grep`/`read` for repository context.

Keep the conversation interactive, direct, and collaborative.
