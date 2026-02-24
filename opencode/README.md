# opencode sync

Sync selected OpenCode assets between this repo and `~/.config/opencode`.

## Scope

- Custom command markdown files listed in `manifest.json`
- Skills listed in `manifest.json`
- Managed config keys listed in `manifest.json`

Current tracked commands:

- `brainstorm`
- `commit`
- `research`

Current tracked skills:

- `arcesse`

Current managed config keys:

- `agent`
- `default_agent`
- `keybinds`

## Requirements

- `uv` must be installed

## Usage

```bash
make save      # copy managed commands/skills/config from ~/.config/opencode into repo
make install   # apply managed commands/skills/config from repo into ~/.config/opencode
make diff      # show differences between repo and ~/.config/opencode
```

Run commands from the `opencode/` directory.
