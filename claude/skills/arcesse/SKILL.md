---
description: Fetch web pages behind Cloudflare or bot protection using a real browser backend. Use as a fallback when WebFetch fails with Cloudflare challenge pages, access denied, bot detection, or returns garbled/empty content from a protected site.
user-invocable: false
allowed-tools: Bash(arcesse *)
---

arcesse is a CLI tool backed by a dockerized Camoufox browser that can bypass
Cloudflare and other bot protection. It is installed globally on this system.

## Commands

- `arcesse read <url>` — returns human-readable markdown (like WebFetch). **Use this by default.**
- `arcesse fetch <url>` — returns raw HTML. Use only when you need the actual markup. Auto-detects file downloads and saves them (use `-o <path>` to choose the output path).
- `arcesse cookies <url>` — solves the challenge and prints cookies in Netscape format. Use `-f json` for JSON.

Both write content to stdout and status/errors to stderr.

## Exporting cookies as proxy

Use `arcesse cookies` to solve the challenge once, then reuse the cookies across multiple requests.
Use a domain-derived filename to avoid collisions:

```bash
arcesse cookies "https://example.com" > /tmp/arcesse-example.com.txt
curl -b /tmp/arcesse-example.com.txt "https://example.com/api/page/1"
curl -b /tmp/arcesse-example.com.txt "https://example.com/api/page/2"
```

Cookies typically expire after ~30 minutes. If requests start failing again, re-run `arcesse cookies`.
Clean up with `rm` when done, or use a project-local path if you prefer keeping cookies elsewhere.

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
