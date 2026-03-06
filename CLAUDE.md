# Project conventions

This repo syncs Claude Code and OpenCode assets between machines.

## Structure

- `claude/agents/<name>.md` — agent definitions
- `claude/skills/<name>/SKILL.md` — skill definitions
- `scripts/manifest.json` — canonical list of tracked agents, skills, and managed settings keys
- `scripts/sync.py` — Claude Code save/install/diff logic (Python, run via `uv`)
- `claude/config/managed-settings.json` — repo-managed subset of Claude Code settings (`settings.json`)
- `scripts/ai-instances.sh` — list active Claude Code / OpenCode processes (`make lsi`)
- `opencode/commands/<name>.md` — OpenCode custom command templates
- `opencode/skills/<name>/...` — OpenCode skill definitions
- `opencode/config/managed.json` — repo-managed subset of OpenCode config (`opencode.json`)
- `opencode/config/managed-tui.json` — repo-managed subset of OpenCode TUI config (`tui.json`)
- `opencode/manifest.json` — OpenCode commands, skills, and managed config keys
- `opencode/scripts/sync.py` — OpenCode save/install/diff logic (Python, run via `uv`)
- `opencode/Makefile` — OpenCode `save` / `install` / `diff` targets

## Rules

### Claude sync

- `uv` is required for Claude sync commands.
- When adding or removing an agent, skill, or managed settings key, update `scripts/manifest.json` first, then run `make save`.
- Keep `agents`, `skills`, and `managed_settings_keys` in `scripts/manifest.json` alphabetically sorted.
- Managed Claude settings keys are currently: `permissions` (in `settings.json`).
- Do not edit files under `claude/` by hand; always edit in `~/.claude` and `make save`.

### OpenCode sync

- `uv` is required for OpenCode sync commands.
- When adding or removing an OpenCode command, skill, or managed config key, update `opencode/manifest.json` first, then run `cd opencode && make save`.
- Keep `commands`, `skills`, and `managed_config_keys` in `opencode/manifest.json` alphabetically sorted.
- Managed OpenCode config keys are currently: `agent`, `default_agent` (in `opencode.json`) and `keybinds` (in `tui.json`).
- Do not edit files under `opencode/commands/`, `opencode/skills/`, or `opencode/config/managed.json` by hand; always edit in `~/.config/opencode` and run `cd opencode && make save`.
