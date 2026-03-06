# claude-setup

Sync custom Claude Code and OpenCode assets between machines.

## Layout

```
claude/agents/    — agent definitions (*.md)
claude/skills/    — skill directories (each with SKILL.md)
opencode/         — OpenCode sync module (manifest, scripts, Makefile)
scripts/          — Python sync script, manifest, and utilities
Makefile          — top-level targets
```

## Usage

```bash
make save      # copy Claude agents, skills, and managed settings from ~/.claude into this repo
make install   # apply Claude agents, skills, and managed settings from this repo into ~/.claude
make diff      # show differences between repo and ~/.claude
make lsi       # list active Claude Code and OpenCode instances
```

## OpenCode sync

OpenCode sync is managed separately under `opencode/`.
Managed config scope is `agent`, `default_agent` (in `opencode.json`) and `keybinds` (in `tui.json`), plus tracked OpenCode commands and skills.

```bash
cd opencode
make save      # copy managed OpenCode commands/skills/config from ~/.config/opencode into repo
make install   # apply managed OpenCode commands/skills/config into ~/.config/opencode
make diff      # show differences between repo and ~/.config/opencode
```

## Adding a new Claude agent, skill, or managed settings key

1. Add the entry to `scripts/manifest.json` (keep lists alphabetically sorted).
2. Run `make save` to pull the files from `~/.claude` into the repo.
3. Commit.

## Adding a new OpenCode command, skill, or managed key

1. Add the entry to `opencode/manifest.json` (keep lists alphabetically sorted).
2. Run `cd opencode && make save` to pull managed assets from `~/.config/opencode`.
3. Commit.
