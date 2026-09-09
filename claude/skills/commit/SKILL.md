---
name: commit
description: Commit changes following the repo's own documented convention where it has one, otherwise the user's house style — module-name prefix (`zsh:`, `ssh:`, `install:`), imperative subject under ~70 chars, a body explaining *why* rather than recapping the diff, and one commit per module or concern. Never adds AI attribution trailers or mentions AI tools.
when_to_use: When the user asks to commit ("commit this", "commit the fix", "/commit"), or when a task being carried out requires making a commit. Not proactively after editing files — committing is the user's call.
argument-hint: what is being committed
allowed-tools: Read, Grep, Glob, Task, Bash(git log *), Bash(git diff *), Bash(git show *), Bash(git merge-base *), Bash(git blame *), Bash(git branch *), Bash(git tag *), Bash(git status), Bash(git ls-files *), Bash(git stash list), Bash(git rev-parse *), Bash(git cat-file *), Bash(git check-ignore *), Bash(git cherry *), Bash(git describe *), Bash(git format-patch *), Bash(git grep *), Bash(git ls-remote *), Bash(git ls-tree *), Bash(git range-diff *), Bash(git reflog show *), Bash(git rev-list *), Bash(git shortlog *), Bash(tree *), Bash(wc *), Bash(jq *), Bash(date *), Bash(echo *), Bash(pwd)
---

Commit the changes made by yourself and the user. If the user mentions
anything more specific, adhere to his wishes.

## Which convention wins

In order of precedence:

1. **A convention the repo documents** — a `CONTRIBUTING.md`, a
   `docs/contributing/` page, a commit template (`git config
   commit.template`), or a pointer in the repo's `CLAUDE.md` /
   `AGENTS.md`. Read it and follow it.
2. **The existing log** — `git log` on the files in the change set;
   match what recent commits actually do.
3. **The house style below.**

Don't go hunting for a conventions doc on every commit; act on one you
already know is there — a pointer in the loaded `CLAUDE.md`, a file
already seen in this session. In a monorepo, the relevant doc is the
nearest one walking up from the changed files, not only the one at the
root.

The tiers layer rather than replace: a doc that pins the subject format
but says nothing about splitting leaves splitting to the house style.
Take from each tier only what the tier above it doesn't cover.

## Style

- **Subject**: short (under ~70 chars), imperative mood ("Add", "Fix",
  "Rename"). For module-scoped changes, prefix with the module name and
  a colon (e.g. `ssh:`, `zsh:`, `git:`, `install:`). Omit the prefix only
  for changes that genuinely span multiple modules or aren't tied to one.
- **Body** (when needed): explain *why* — the motivation, constraint, or
  incident that prompted the change — not a recap of the diff. Skip the
  body entirely for self-evident changes.

## Splitting

Prefer one commit per module or concern. If a single edit touches multiple
modules (e.g. installer infrastructure + a module's use of it), split into
separate commits even if it requires a staging trick (`git add -p`,
temporarily reverting a hunk, etc.). Avoid grab-bag rollups.

## Attribution

- Do not add a `Co-Authored-By:` trailer. Do not mention Claude, Opus,
  Sonnet, Haiku, Anthropic or any other tool/model in the commit.
- Trailers the *repo* asks for — `Signed-off-by:`, a DCO line, an issue
  or ticket reference — are part of its convention, so add them. The rule
  above is about not advertising the tooling, not about keeping trailers
  out of the message.

## Hard rules

How git is driven. No repo convention overrides these:

- Do not use `git -C`. If you need to operate in a different directory,
  `cd` there first.
- Do not use `git commit -a` (or `-am`). Always stage the intended files
  by name with `git add <path>` first, then commit.

$ARGUMENTS
