---
description: research a topic, come back with an answer, do not code
argument-hint: what is being researched
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash, WebFetch, WebSearch, Task
---

Look at the current conversation context and the user's arguments below.
Research the topic thoroughly and return an answer. Do not code.

If the research would benefit from exploring multiple angles simultaneously, you
may dispatch sub-agents via the Task tool (e.g. codebase-researcher,
idea-generator). Distill enough conversation context into the prompt that the
agent can work without seeing this conversation.

$ARGUMENTS
