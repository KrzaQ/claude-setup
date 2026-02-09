#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

source "$SCRIPT_DIR/manifest.sh"

has_diff=0

for agent in "${AGENTS[@]}"; do
    repo="$REPO_DIR/claude/agents/$agent"
    live="$CLAUDE_DIR/agents/$agent"
    if [[ -f "$repo" && -f "$live" ]]; then
        diff -u "$repo" "$live" --label "repo: agents/$agent" --label "live: agents/$agent" || has_diff=1
    elif [[ -f "$repo" ]]; then
        echo "agents/$agent: exists in repo but not in ~/.claude"
        has_diff=1
    elif [[ -f "$live" ]]; then
        echo "agents/$agent: exists in ~/.claude but not in repo"
        has_diff=1
    fi
done

for skill in "${SKILLS[@]}"; do
    repo="$REPO_DIR/claude/skills/$skill"
    live="$CLAUDE_DIR/skills/$skill"
    if [[ -d "$repo" && -d "$live" ]]; then
        diff -ru "$repo" "$live" --label "repo: skills/$skill" --label "live: skills/$skill" || has_diff=1
    elif [[ -d "$repo" ]]; then
        echo "skills/$skill/: exists in repo but not in ~/.claude"
        has_diff=1
    elif [[ -d "$live" ]]; then
        echo "skills/$skill/: exists in ~/.claude but not in repo"
        has_diff=1
    fi
done

if [[ $has_diff -eq 0 ]]; then
    echo "No differences."
fi
