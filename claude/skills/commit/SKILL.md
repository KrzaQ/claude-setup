---
name: commit
description: Commit changes in the user's house style — module-name prefix (`zsh:`, `ssh:`, `install:`), imperative subject under ~70 chars, a body explaining *why* rather than recapping the diff, and one commit per module or concern. Never adds Co-Authored-By trailers or mentions AI tools.
when_to_use: When the user asks to commit ("commit this", "commit the fix", "/commit"), or when a task being carried out requires making a commit. Not proactively after editing files — committing is the user's call.
argument-hint: what is being committed
allowed-tools: Read, Grep, Glob, Task, Bash(git log *), Bash(git diff *), Bash(git show *), Bash(git merge-base *), Bash(git blame *), Bash(git branch *), Bash(git tag *), Bash(git status), Bash(git ls-files *), Bash(git stash list), Bash(git rev-parse *), Bash(git cat-file *), Bash(git check-ignore *), Bash(git cherry *), Bash(git describe *), Bash(git format-patch *), Bash(git grep *), Bash(git ls-remote *), Bash(git ls-tree *), Bash(git range-diff *), Bash(git reflog show *), Bash(git rev-list *), Bash(git shortlog *), Bash(tree *), Bash(wc *), Bash(jq *), Bash(date *), Bash(echo *), Bash(pwd)
---

Commit the changes made by yourself and the user. If the user mentions
anything more specific, adhere to his wishes.

## Style

- **Subject**: short (under ~70 chars), imperative mood ("Add", "Fix",
  "Rename"). For module-scoped changes, prefix with the module name and
  a colon (e.g. `ssh:`, `zsh:`, `git:`, `install:`). Omit the prefix only
  for changes that genuinely span multiple modules or aren't tied to one.
- **Body** (when needed): explain *why* — the motivation, constraint, or
  incident that prompted the change — not a recap of the diff. Skip the
  body entirely for self-evident changes.
- Follow the existing commit style. If unsure, run `git log` on the files
  in the change set and match what's there.

## Splitting

Prefer one commit per module or concern. If a single edit touches multiple
modules (e.g. installer infrastructure + a module's use of it), split into
separate commits even if it requires a staging trick (`git add -p`,
temporarily reverting a hunk, etc.). Avoid grab-bag rollups.

## Hard rules

- Do not add a `Co-Authored-By:` trailer. Do not mention Claude, Opus,
  Sonnet, Haiku, Anthropic or any other tool/model in the commit.
- Do not use `git -C`. If you need to operate in a different directory,
  `cd` there first.

$ARGUMENTS
