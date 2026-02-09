---
description: challenge an idea or approach by arguing the opposite — find flaws, risks, and overlooked alternatives
argument-hint: idea or approach to challenge
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, WebFetch, WebSearch, Task
---

Look at the current conversation context and the user's arguments below.
Formulate a clear, self-contained prompt that captures the relevant context and
the idea/approach being challenged, then dispatch it to an idea-generator agent
using the Task tool with `subagent_type: "idea-generator"`.

The prompt you send to the agent should include:
- Enough background that the agent can work without seeing the conversation
- The creative lens: devil's advocate — argue AGAINST the idea, challenge
  assumptions, find flaws, identify risks, and propose the opposite approach
- Be constructive but relentless. If the idea is solid, say so — but only after
  genuinely trying to break it

Present the agent's results to the user when it returns.

$ARGUMENTS
