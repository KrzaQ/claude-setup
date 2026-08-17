---
description: interview the user relentlessly about a plan or design until reaching shared understanding
argument-hint: plan or design to be grilled on
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, WebFetch, WebSearch, Task, AskUserQuestion, Bash(git log *), Bash(git diff *), Bash(git show *), Bash(git merge-base *), Bash(git blame *), Bash(git branch *), Bash(git tag *), Bash(git status), Bash(git ls-files *), Bash(git stash list), Bash(git rev-parse *), Bash(git cat-file *), Bash(git check-ignore *), Bash(git cherry *), Bash(git describe *), Bash(git format-patch *), Bash(git grep *), Bash(git ls-remote *), Bash(git ls-tree *), Bash(git range-diff *), Bash(git reflog show *), Bash(git rev-list *), Bash(git shortlog *), Bash(tree *), Bash(wc *), Bash(jq *), Bash(date *), Bash(echo *), Bash(pwd)
---

Interview me relentlessly about every aspect of this plan until we reach a shared
understanding. Walk down each branch of the design tree, resolving dependencies
between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

Ask in prose or via AskUserQuestion, whichever suits the question better.

If a question can be answered by exploring the codebase, explore the codebase instead.

$ARGUMENTS
