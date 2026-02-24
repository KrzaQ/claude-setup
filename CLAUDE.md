# Project conventions

This repo syncs Claude Code agents and skills between machines via `~/.claude`.

## Structure

- `claude/agents/<name>.md` — agent definitions
- `claude/skills/<name>/SKILL.md` — skill definitions
- `scripts/manifest.sh` — canonical list of tracked agents and skills
- `scripts/save.sh` / `install.sh` / `diff.sh` — sync scripts driven by the manifest

## Rules

- When adding or removing an agent or skill, update `scripts/manifest.sh` first, then run `make save`.
- Keep the `AGENTS` and `SKILLS` arrays in `manifest.sh` alphabetically sorted.
- Do not edit files under `claude/` by hand; always edit in `~/.claude` and `make save`.
