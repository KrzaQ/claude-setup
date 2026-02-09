#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

source "$SCRIPT_DIR/manifest.sh"

for agent in "${AGENTS[@]}"; do
    src="$REPO_DIR/claude/agents/$agent"
    dst="$CLAUDE_DIR/agents/$agent"
    if [[ -f "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        cp "$src" "$dst"
        echo "installed agents/$agent"
    else
        echo "WARN: $src not found in repo, skipping" >&2
    fi
done

for skill in "${SKILLS[@]}"; do
    src="$REPO_DIR/claude/skills/$skill"
    dst="$CLAUDE_DIR/skills/$skill"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        cp -r "$src"/. "$dst"/
        echo "installed skills/$skill/"
    else
        echo "WARN: $src not found in repo, skipping" >&2
    fi
done
