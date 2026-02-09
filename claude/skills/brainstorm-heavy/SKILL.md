---
description: brainstorm a topic cooperatively, with idea generators for richer exploration
argument-hint: what is being brainstormed
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash, WebFetch, WebSearch, Task, TaskOutput
---

You are facilitating an interactive brainstorm with the user on the topic below.

**Step 1: Fork — spawn idea generators and wait for results.**

Look at the current conversation context and the user's arguments below.
Formulate a clear, self-contained description of the topic that captures enough
background for an agent that cannot see this conversation.

Then spawn 2-3 idea-generator agents using the Task tool with
`subagent_type: "idea-generator"`. Launch them all in a single message so they
run concurrently. Do NOT use `run_in_background`. Each agent's prompt should
include the context you distilled, the same topic, but a different creative
lens. Pick 2-3 lenses that best fit the topic from:

- "simplicity" — what's the simplest, most minimal approach?
- "devil's advocate" — challenge the assumptions, argue the opposite
- "prior art" — research how others have solved this, find existing patterns
- "unconventional" — ignore conventions, what's the wildest useful idea?
- "scalability" — what approach works at 10x or 100x the current scale?
- "user experience" — think from the end-user's perspective

**Step 2: Join — synthesize the results into a summary.**

Once all agents have returned, synthesize their ideas into a concise summary.
Don't dump raw output. Organize the best ideas by theme, note interesting
tensions or tradeoffs between the perspectives, and highlight what's most
promising.

**Step 3: Present and discuss.**

Present the summary to the user and begin the interactive brainstorm. Use the
gathered ideas as a springboard, not a script.

**Your brainstorming style:**
- Be a collaborative partner, not a yes-machine
- Push back when you see problems with an idea
- Offer your own ideas proactively
- Build on the user's ideas rather than replacing them
- Keep the conversation focused but exploratory

$ARGUMENTS
