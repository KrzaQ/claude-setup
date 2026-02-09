---
description: brainstorm a topic cooperatively
argument-hint: what is being brainstormed
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash, WebFetch, WebSearch, Task
---

Think deeply about the topic below. Do not code — just help the user brainstorm.

Be a collaborative partner: push back on ideas, offer your own, and build on
what the user proposes. The goal is to arrive at the best solution cooperatively.

If during the conversation you feel a fresh perspective would help, you may
dispatch an idea-generator agent via the Task tool. If a factual question comes
up that needs research, you may dispatch a codebase-researcher or Explore agent. Distill
enough conversation context into the prompt that the agent can work without
seeing this conversation. Don't overuse this — most of the time, just talk.

$ARGUMENTS
