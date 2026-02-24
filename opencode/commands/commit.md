---
description: Prepare a safe, focused git commit.
---

Use this command only when the user explicitly asks to create a commit.

If provided, treat this as additional commit intent/context:
$ARGUMENTS

## Commit workflow

1. Inspect state with `git status`, `git diff`, and recent `git log`.
2. Stage only relevant files for the requested change.
3. Exclude likely secrets (for example `.env`, credential files) unless the user explicitly insists.
4. Write a concise commit message focused on intent and outcome.
5. Commit, then verify with `git status`.

## Safety rules

- Never rewrite history unless explicitly requested.
- Do not use destructive commands such as hard reset or force push.
- Do not bypass hooks (`--no-verify`) unless explicitly requested.
- Avoid `git commit --amend` unless the user explicitly requests amend behavior.
- If hooks fail, fix issues and create a new commit.
- If there are no changes, report that nothing can be committed.

## Message quality

- Match existing repository commit style.
- Keep the message specific and useful.
- Do not mention assistant/vendor names in commit messages.
