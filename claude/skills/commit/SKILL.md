---
description: commit
argument-hint: what is being committed
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Task, Bash(git log *), Bash(git diff *), Bash(git show *), Bash(git merge-base *), Bash(git blame *), Bash(git branch *), Bash(git tag *), Bash(git status), Bash(git ls-files *), Bash(git stash list), Bash(git rev-parse *), Bash(git cat-file *), Bash(git check-ignore *), Bash(git cherry *), Bash(git describe *), Bash(git format-patch *), Bash(git grep *), Bash(git ls-remote *), Bash(git ls-tree *), Bash(git range-diff *), Bash(git reflog show *), Bash(git rev-list *), Bash(git shortlog *), Bash(tree *), Bash(wc *), Bash(jq *), Bash(date *), Bash(echo *), Bash(pwd)
---

Commit the changes made by yourself and the user. If the user mentions
anything more specific, adhere to his wishes. Do not mention Claude, Opus,
Sonnet, Haiku, Anthropic or anything else.

Do not use `git -C`. If you need to run git commands in a directory different
from the current one, `cd` to that directory first.

Follow the commit style from previous commits. If necessary, look at the last
few commits for a particular file in the committed change set.

$ARGUMENTS
