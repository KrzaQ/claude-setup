---
description: commit
argument-hint: what is being committed
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash(git status *), Bash(git diff *), Bash(git log *), Task
---

Commit the changes made by yourself and the user. If the user mentions
anything more specific, adhere to his wishes. Do not mention Claude, Opus,
Sonnet, Haiku, Anthropic or anything else.

Do not use `git -C`. If you need to run git commands in a directory different
from the current one, `cd` to that directory first.

Follow the commit style from previous commits. If necessary, look at the last
few commits for a particular file in the committed change set.

$ARGUMENTS
