---
description: create or update a project Makefile in my house style
argument-hint: what the makefile should build/run (optional — infer if blank)
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Write, Edit, Bash(ls *), Bash(cat *), Bash(test *), Bash(find *), Bash(git ls-files *), Bash(git status), Bash(git check-ignore *)
---

Create or update the project's root `Makefile` in my house style.

The Makefile is a **uniform, memorable front door** to the project's tooling —
a task runner, not a build system. Each recipe is a thin wrapper around the
native tool (`cargo`, `npm`, `uv`, `dub`, `cmake`, `docker`, ...). The whole
point is that `make build`, `make test`, `make run` mean the same thing in
every repo regardless of language.

## First, inspect the project

- Detect the toolchain from the files present: `Cargo.toml` (cargo),
  `package.json` (npm — read its `scripts`), `pyproject.toml` (uv),
  `CMakeLists.txt`/`conanfile` (cmake+conan), `dub.json`/`dub.sdl` (dub),
  `Dockerfile`/`compose.yaml` (docker). Wire recipes to the tools and scripts
  that actually exist — don't invent commands.
- If a `Makefile` already exists, **update it in place**: keep the user's custom
  targets and only reconcile structure/naming. Don't clobber.
- If sibling/related repos have Makefiles, match their conventions.

## Rules

- **`.PHONY` first**, listing every target (they're virtually always phony).
  One line; backslash-continue if it gets long.
- **Consistent target vocabulary — same verb, same meaning everywhere.** Prefer
  these names over synonyms: `build`, `test`, `lint`, `format` (or `fmt`),
  `run` (or `dev`), `install`, `clean`. Plus as needed: `help`, `upload`/`push`,
  `docker-build`, `docker-run`, `docker-save`. Don't invent a new name for a
  concept that already has one here.
- **Chain pipelines with prerequisites**, so running the end target runs the
  whole chain: `build: install format lint`, `upload: build`, `preview: build`,
  `docker-save: docker-build`. For C++/cmake projects use the
  `conan → configure → build → test` chain (each depends on the previous).
- **Overridable config via `?=` at the top**, so it can be overridden on the
  command line: `IMAGE_NAME ?= foo`, `BUILD_TYPE ?= RelWithDebInfo`,
  `TEXT ?= "Hello"`. Then `make run TEXT="Hi"` works.
- **`clean` removes generated artifacts**, language-appropriate: `cargo clean`,
  `rm -rf node_modules dist`, `rm -rf build`, `.venv`, `__pycache__`.
- Recipes use real **tabs**. Prefix informational/`help` recipes with `@` to
  silence the command echo.
- For a target that requires an argument, **guard it**: check for the empty var,
  print a `Usage:` line, and `exit 2`.

## Self-documenting help

For anything beyond a couple of targets, add a `help` target and
`.DEFAULT_GOAL := help` so bare `make` lists what's available. Document each
target inline with a `## description` after the colon, and use this recipe
verbatim (it's the standard across my repos):

```make
help: ## Show this help
	@grep -hE '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "; w = 12} { k[NR] = $$1; v[NR] = $$2; if (length($$1) > w) w = length($$1) } \
		     END { for (i = 1; i <= NR; i++) printf "  \033[36m%-*s\033[0m %s\n", w, k[i], v[i] }'
```

Two things it gets right that are easy to get wrong:

- **The character class covers every character a target name can contain.**
  Digits are easy to leave out, and the failure is silent: `e2e` or `s3-sync`
  simply never appears in the listing, while `help` still looks like it works.
- **The description column measures itself.** awk buffers the matches, takes the
  widest target name, and feeds it to `printf` as a `*` field width, with 12 as a
  floor. A hardcoded width silently collides with the description the first time
  someone adds a `docker-build-base`, and nobody goes back to widen it.

Don't unroll this back into a single `printf` per line — the buffering is the
whole point.

Tiny single-purpose Makefiles (2–3 targets) can skip `help` and the inline
`##` docs — don't over-engineer.

## Committed vs machine-specific split

- The committed `Makefile` must be **reproducible on any clone** — no personal
  hostnames, deploy targets, or extra git remotes in it.
- Machine-specific targets (deploy hosts, extra push remotes like
  `git push gh master && git push kq master`) go in **`Makefile.local`**, pulled
  in by making the **last line** of the Makefile `-include Makefile.local`. The
  leading `-` means "include if present, don't error if missing".
- **`Makefile.local` must be gitignored.** When you add one, also add a committed
  `Makefile.local.example` documenting the expected targets/variables, add
  `Makefile.local` to `.gitignore`, and put a short header comment in the main
  Makefile pointing to it. Only introduce `Makefile.local` when there's an actual
  machine-specific target to hold — don't add an empty one.

## Reference skeleton (npm — adapt the tool per language)

```make
.PHONY: help install format lint build run upload clean
.DEFAULT_GOAL := help

help: ## Show this help
	@grep -hE '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "; w = 12} { k[NR] = $$1; v[NR] = $$2; if (length($$1) > w) w = length($$1) } \
		     END { for (i = 1; i <= NR; i++) printf "  \033[36m%-*s\033[0m %s\n", w, k[i], v[i] }'

install: ## Install dependencies
	npm install

format: ## Format code
	npm run format

lint: ## Run linters
	npm run lint

build: install format lint ## Install, format, lint, then build
	npm run build

run: install ## Start the dev server
	npm run dev -- --host

upload: build ## Build and deploy
	./scripts/upload.sh

clean: ## Remove build artifacts
	rm -rf node_modules dist

-include Makefile.local
```

After writing the Makefile, briefly tell the user what targets you created and
any assumptions (e.g. "assumed `./scripts/upload.sh` for deploy — create it or
tell me the real command").

$ARGUMENTS
