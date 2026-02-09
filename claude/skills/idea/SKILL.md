---
description: get a fresh creative perspective on a topic or problem
argument-hint: topic or question to explore
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, WebFetch, WebSearch, Task
---

Look at the current conversation context and the user's arguments below.
Formulate a clear, self-contained prompt that captures the relevant context and
the question, then dispatch it to an idea-generator agent using the Task tool
with `subagent_type: "idea-generator"`.

The prompt you send to the agent should include:
- Enough background that the agent can work without seeing the conversation
- The creative lens: open/creative — explore freely, no particular angle forced
- A clear question or topic to generate ideas about

Present the agent's results to the user when it returns.

$ARGUMENTS
