.PHONY: save install diff lsi

save:
	@uv run python scripts/sync.py save

install:
	@uv run python scripts/sync.py install

diff:
	@uv run python scripts/sync.py diff

lsi:
	@bash scripts/ai-instances.sh

-include Makefile.local
