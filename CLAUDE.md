# Project conventions

This repo syncs Claude Code and OpenCode assets between machines.

## Structure

- `claude/agents/<name>.md` — agent definitions
- `claude/skills/<name>/SKILL.md` — skill definitions
- `scripts/manifest.sh` — canonical list of tracked agents and skills
- `scripts/save.sh` / `install.sh` / `diff.sh` — sync scripts driven by the manifest
- `scripts/ai-instances.sh` — list active Claude Code / OpenCode processes (`make lsi`)
- `opencode/commands/<name>.md` — OpenCode custom command templates
- `opencode/skills/<name>/...` — OpenCode skill definitions
- `opencode/config/managed.json` — repo-managed subset of OpenCode config
- `opencode/manifest.json` — OpenCode commands, skills, and managed config keys
- `opencode/scripts/sync.py` — OpenCode save/install/diff logic (Python, run via `uv`)
- `opencode/Makefile` — OpenCode `save` / `install` / `diff` targets

## Rules

### Claude sync

- When adding or removing an agent or skill, update `scripts/manifest.sh` first, then run `make save`.
- Keep the `AGENTS` and `SKILLS` arrays in `manifest.sh` alphabetically sorted.
- Do not edit files under `claude/` by hand; always edit in `~/.claude` and `make save`.

### OpenCode sync

- `uv` is required for OpenCode sync commands.
- When adding or removing an OpenCode command, skill, or managed config key, update `opencode/manifest.json` first, then run `cd opencode && make save`.
- Keep `commands`, `skills`, and `managed_config_keys` in `opencode/manifest.json` alphabetically sorted.
- Managed OpenCode config keys are currently: `agent`, `default_agent`, `keybinds`.
- Do not edit files under `opencode/commands/`, `opencode/skills/`, or `opencode/config/managed.json` by hand; always edit in `~/.config/opencode` and run `cd opencode && make save`.
