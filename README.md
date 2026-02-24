# claude-setup

Sync custom Claude Code agents and skills between machines.

## Layout

```
claude/agents/    — agent definitions (*.md)
claude/skills/    — skill directories (each with SKILL.md)
scripts/          — save/install/diff shell scripts
Makefile          — top-level targets
```

## Usage

```bash
make save      # copy agents & skills from ~/.claude into this repo
make install   # copy agents & skills from this repo into ~/.claude
make diff      # show differences between repo and ~/.claude
```

## Adding a new agent or skill

1. Add the entry to `scripts/manifest.sh` (keep lists alphabetically sorted).
2. Run `make save` to pull the files from `~/.claude` into the repo.
3. Commit.
