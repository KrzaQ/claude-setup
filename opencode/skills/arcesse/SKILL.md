---
name: arcesse
description: Fetch Cloudflare- or bot-protected pages with arcesse via bash when webfetch fails.
compatibility: opencode
metadata:
  category: web-retrieval
  source: ported-from-claude
---

Use this skill when normal `webfetch` cannot retrieve a page due to bot protection.

## When to use

- `webfetch` returns a challenge page (for example, "Just a moment...")
- `webfetch` returns access denied, empty content, or obviously garbled output
- The user explicitly asks to fetch a Cloudflare-protected page

## How to run arcesse

Use the `bash` tool and prefer these commands:

- `arcesse read "<url>"` for markdown-like readable output (default)
- `arcesse fetch "<url>"` for raw HTML when markup is required
- `arcesse cookies "<url>"` when the user needs cookie export for downstream requests

If cookie handoff is needed:

```bash
arcesse cookies "https://example.com" > /tmp/cookies.txt
curl -b /tmp/cookies.txt "https://example.com/api/data"
```

## Failure handling

If arcesse reports a backend connection error, explain that the arcesse browser backend is not running and ask the user to start it (for example, `docker compose up -d` in the arcesse project).
