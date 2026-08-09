.PHONY: help save install diff
.DEFAULT_GOAL := help

help: ## Show this help
	@grep -hE '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "; w = 12} { k[NR] = $$1; v[NR] = $$2; if (length($$1) > w) w = length($$1) } \
		     END { for (i = 1; i <= NR; i++) printf "  \033[36m%-*s\033[0m %s\n", w, k[i], v[i] }'

save: ## Copy tracked OpenCode assets from ~/.config/opencode into the repo
	@uv run python scripts/sync.py save

install: ## Copy tracked OpenCode assets from the repo into ~/.config/opencode
	@uv run python scripts/sync.py install

diff: ## Show where the repo and ~/.config/opencode disagree
	@uv run python scripts/sync.py diff
