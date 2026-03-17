---
description: research a topic, come back with an answer, do not code
argument-hint: what is being researched
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, WebFetch, WebSearch, Task, Bash(git log *), Bash(git diff *), Bash(git show *), Bash(git merge-base *), Bash(git blame *), Bash(git branch *), Bash(git tag *), Bash(git status), Bash(git ls-files *), Bash(git stash list), Bash(git rev-parse *), Bash(git cat-file *), Bash(git check-ignore *), Bash(git cherry *), Bash(git describe *), Bash(git format-patch *), Bash(git grep *), Bash(git ls-remote *), Bash(git ls-tree *), Bash(git range-diff *), Bash(git reflog show *), Bash(git rev-list *), Bash(git shortlog *), Bash(tree *), Bash(wc *), Bash(jq *), Bash(date *), Bash(echo *), Bash(pwd)
---

Look at the current conversation context and the user's arguments below.
Research the topic thoroughly and return an answer. Do not code.

If the research would benefit from exploring multiple angles simultaneously, you
may dispatch sub-agents via the Task tool (e.g. codebase-researcher,
idea-generator). Distill enough conversation context into the prompt that the
agent can work without seeing this conversation.

$ARGUMENTS
