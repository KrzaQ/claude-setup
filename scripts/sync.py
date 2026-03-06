#!/usr/bin/env python3
from __future__ import annotations

import argparse
import difflib
import json
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any


REPO_DIR = Path(__file__).resolve().parents[1]
MANIFEST_PATH = REPO_DIR / "scripts" / "manifest.json"
REPO_AGENTS_DIR = REPO_DIR / "claude" / "agents"
REPO_SKILLS_DIR = REPO_DIR / "claude" / "skills"
REPO_SETTINGS_PATH = REPO_DIR / "claude" / "config" / "managed-settings.json"

LIVE_DIR = Path.home() / ".claude"
LIVE_AGENTS_DIR = LIVE_DIR / "agents"
LIVE_SKILLS_DIR = LIVE_DIR / "skills"
LIVE_SETTINGS_PATH = LIVE_DIR / "settings.json"


def load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as f:
        data = json.load(f)
    if not isinstance(data, dict):
        raise ValueError(f"Expected JSON object in {path}")
    return data


def write_json(path: Path, data: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    text = json.dumps(data, indent=2, sort_keys=True)
    path.write_text(text + "\n", encoding="utf-8")


def load_string_list(manifest: dict[str, Any], key: str) -> list[str]:
    items = manifest.get(key)
    if not isinstance(items, list) or not all(isinstance(item, str) for item in items):
        raise ValueError(f"manifest.json: '{key}' must be a list of strings")
    if items != sorted(items):
        raise ValueError(f"manifest.json: '{key}' must be alphabetically sorted")
    if len(items) != len(set(items)):
        raise ValueError(f"manifest.json: '{key}' contains duplicates")
    return items


def load_manifest() -> tuple[list[str], list[str], list[str]]:
    manifest = load_json(MANIFEST_PATH)
    agents = load_string_list(manifest, "agents")
    skills = load_string_list(manifest, "skills")
    managed_keys = load_string_list(manifest, "managed_settings_keys")
    return agents, skills, managed_keys


def extract_managed(config: dict[str, Any], managed_keys: list[str]) -> dict[str, Any]:
    managed: dict[str, Any] = {}
    for key in managed_keys:
        if key in config:
            managed[key] = config[key]
    return managed


def normalize_settings(settings: dict[str, Any]) -> dict[str, Any]:
    """Normalize managed settings for deterministic repo storage."""
    if "permissions" in settings:
        perms = settings["permissions"]
        if "allow" in perms and isinstance(perms["allow"], list):
            perms["allow"] = sorted(perms["allow"])
        if "deny" in perms and isinstance(perms["deny"], list):
            perms["deny"] = sorted(perms["deny"])
    return settings


def copy_tree_overlay(src: Path, dst: Path) -> None:
    dst.mkdir(parents=True, exist_ok=True)
    for entry in src.iterdir():
        target = dst / entry.name
        if entry.is_dir():
            shutil.copytree(entry, target, dirs_exist_ok=True)
        else:
            shutil.copy2(entry, target)


def copy_file(src: Path, dst: Path) -> None:
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)


def save() -> None:
    agents, skills, managed_keys = load_manifest()

    for agent in agents:
        src = LIVE_AGENTS_DIR / agent
        dst = REPO_AGENTS_DIR / agent
        if src.is_file():
            copy_file(src, dst)
            print(f"saved agents/{agent}")
        else:
            print(f"WARN: {src} not found, skipping", file=sys.stderr)

    for skill in skills:
        src = LIVE_SKILLS_DIR / skill
        dst = REPO_SKILLS_DIR / skill
        if src.is_dir():
            copy_tree_overlay(src, dst)
            print(f"saved skills/{skill}/")
        else:
            print(f"WARN: {src} not found, skipping", file=sys.stderr)

    if LIVE_SETTINGS_PATH.is_file():
        live_config = load_json(LIVE_SETTINGS_PATH)
        managed = extract_managed(live_config, managed_keys)
        managed = normalize_settings(managed)
        write_json(REPO_SETTINGS_PATH, managed)
        print("saved config/managed-settings.json")
    else:
        print(f"WARN: {LIVE_SETTINGS_PATH} not found, skipping", file=sys.stderr)


def install() -> None:
    agents, skills, managed_keys = load_manifest()

    for agent in agents:
        src = REPO_AGENTS_DIR / agent
        dst = LIVE_AGENTS_DIR / agent
        if src.is_file():
            copy_file(src, dst)
            print(f"installed agents/{agent}")
        else:
            print(f"WARN: {src} not found in repo, skipping", file=sys.stderr)

    for skill in skills:
        src = REPO_SKILLS_DIR / skill
        dst = LIVE_SKILLS_DIR / skill
        if src.is_dir():
            copy_tree_overlay(src, dst)
            print(f"installed skills/{skill}/")
        else:
            print(f"WARN: {src} not found in repo, skipping", file=sys.stderr)

    if REPO_SETTINGS_PATH.is_file():
        managed = load_json(REPO_SETTINGS_PATH)

        if LIVE_SETTINGS_PATH.is_file():
            live_config = load_json(LIVE_SETTINGS_PATH)
        else:
            live_config = {}

        for key in managed_keys:
            if key in managed:
                live_config[key] = managed[key]
            else:
                print(
                    f"WARN: managed settings key '{key}' missing, leaving local value unchanged",
                    file=sys.stderr,
                )

        write_json(LIVE_SETTINGS_PATH, live_config)
        print("installed config/managed-settings.json into ~/.claude/settings.json")
    else:
        print(f"WARN: {REPO_SETTINGS_PATH} not found in repo, skipping", file=sys.stderr)


def diff_agents(agents: list[str]) -> bool:
    has_diff = False

    for agent in agents:
        repo = REPO_AGENTS_DIR / agent
        live = LIVE_AGENTS_DIR / agent
        if repo.is_file() and live.is_file():
            result = subprocess.run(
                [
                    "diff",
                    "-u",
                    str(repo),
                    str(live),
                    "--label",
                    f"repo: agents/{agent}",
                    "--label",
                    f"live: agents/{agent}",
                ],
                check=False,
            )
            if result.returncode == 1:
                has_diff = True
            elif result.returncode != 0:
                raise RuntimeError(f"diff failed for agent {agent}")
        elif repo.is_file():
            print(f"agents/{agent}: exists in repo but not in ~/.claude")
            has_diff = True
        elif live.is_file():
            print(f"agents/{agent}: exists in ~/.claude but not in repo")
            has_diff = True

    return has_diff


def diff_skills(skills: list[str]) -> bool:
    has_diff = False

    for skill in skills:
        repo = REPO_SKILLS_DIR / skill
        live = LIVE_SKILLS_DIR / skill
        if repo.is_dir() and live.is_dir():
            result = subprocess.run(
                [
                    "diff",
                    "-ru",
                    str(repo),
                    str(live),
                    "--label",
                    f"repo: skills/{skill}",
                    "--label",
                    f"live: skills/{skill}",
                ],
                check=False,
            )
            if result.returncode == 1:
                has_diff = True
            elif result.returncode != 0:
                raise RuntimeError(f"diff failed for skill {skill}")
        elif repo.is_dir():
            print(f"skills/{skill}/: exists in repo but not in ~/.claude")
            has_diff = True
        elif live.is_dir():
            print(f"skills/{skill}/: exists in ~/.claude but not in repo")
            has_diff = True

    return has_diff


def diff_settings(managed_keys: list[str]) -> bool:
    has_diff = False

    if REPO_SETTINGS_PATH.is_file() and LIVE_SETTINGS_PATH.is_file():
        repo_managed = normalize_settings(load_json(REPO_SETTINGS_PATH))
        live_config = load_json(LIVE_SETTINGS_PATH)
        live_managed = normalize_settings(extract_managed(live_config, managed_keys))

        repo_text = json.dumps(repo_managed, indent=2, sort_keys=True) + "\n"
        live_text = json.dumps(live_managed, indent=2, sort_keys=True) + "\n"

        if repo_text != live_text:
            has_diff = True
            delta = difflib.unified_diff(
                repo_text.splitlines(keepends=True),
                live_text.splitlines(keepends=True),
                fromfile="repo: config/managed-settings.json",
                tofile="live: managed subset of ~/.claude/settings.json",
            )
            for line in delta:
                sys.stdout.write(line)
    elif REPO_SETTINGS_PATH.is_file():
        print(
            "config/managed-settings.json: exists in repo but ~/.claude/settings.json is missing"
        )
        has_diff = True
    elif LIVE_SETTINGS_PATH.is_file():
        live_config = load_json(LIVE_SETTINGS_PATH)
        live_managed = extract_managed(live_config, managed_keys)
        if live_managed:
            print(
                "config/managed-settings.json: missing in repo but managed keys exist in ~/.claude/settings.json"
            )
            has_diff = True

    return has_diff


def show_diff() -> None:
    agents, skills, managed_keys = load_manifest()
    has_diff = False

    has_diff = diff_agents(agents) or has_diff
    has_diff = diff_skills(skills) or has_diff
    has_diff = diff_settings(managed_keys) or has_diff

    if not has_diff:
        print("No differences.")


def main() -> int:
    parser = argparse.ArgumentParser(description="Sync managed Claude Code assets")
    parser.add_argument("command", choices=["save", "install", "diff"])
    args = parser.parse_args()

    if args.command == "save":
        save()
    elif args.command == "install":
        install()
    else:
        show_diff()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
