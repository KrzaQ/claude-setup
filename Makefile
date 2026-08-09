.PHONY: help save install diff lsi
.DEFAULT_GOAL := help

# Machine-specific targets (extra push remotes, deploy hosts) belong in
# Makefile.local, which is gitignored. See Makefile.local.example.

help: ## Show this help
	@grep -hE '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "; w = 12} { k[NR] = $$1; v[NR] = $$2; if (length($$1) > w) w = length($$1) } \
		     END { for (i = 1; i <= NR; i++) printf "  \033[36m%-*s\033[0m %s\n", w, k[i], v[i] }'

save: ## Copy tracked Claude assets from ~/.claude into the repo
	@uv run python scripts/sync.py save

install: ## Copy tracked Claude assets from the repo into ~/.claude
	@uv run python scripts/sync.py install

diff: ## Show where the repo and ~/.claude disagree
	@uv run python scripts/sync.py diff

lsi: ## List running Claude Code / OpenCode processes
	@bash scripts/ai-instances.sh

-include Makefile.local
