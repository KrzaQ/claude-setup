---
description: Fetch web pages behind Cloudflare or bot protection using a real browser backend. Use as a fallback when WebFetch fails with Cloudflare challenge pages, access denied, bot detection, or returns garbled/empty content from a protected site.
user-invocable: false
allowed-tools: Bash(arcesse *)
---

arcesse is a CLI tool backed by a dockerized Camoufox browser that can bypass
Cloudflare and other bot protection. It is installed globally on this system.

## Commands

- `arcesse read <url>` — returns human-readable markdown (like WebFetch). **Use this by default.**
- `arcesse fetch <url>` — returns raw HTML. Use only when you need the actual markup.
- `arcesse cookies <url>` — solves the challenge and prints cookies in Netscape format. Use `-f json` for JSON.

Both write content to stdout and status/errors to stderr.

## Exporting cookies as proxy

Use `arcesse cookies` to get Cloudflare bypass cookies, then pass them to curl or other tools:

```bash
arcesse cookies "https://example.com" > /tmp/cookies.txt
curl -b /tmp/cookies.txt "https://example.com/api/data"
```

## Usage

```bash
# Typical usage — pipe through head if you only need a summary
arcesse read "https://example.com/protected-page"

# Raw HTML when needed
arcesse fetch "https://example.com/protected-page"
```

## When to use

1. WebFetch returned a Cloudflare challenge page, "Just a moment...", or access denied
2. WebFetch returned empty or garbled content from a site that should have content
3. The user explicitly asks to fetch a Cloudflare-protected or bot-protected URL

## Requirements

The backend must be running (`docker compose up -d` in the arcesse project).
If arcesse fails with a connection error, tell the user the backend isn't running.
