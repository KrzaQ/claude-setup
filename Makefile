.PHONY: save install diff lsi

save:
	@bash scripts/save.sh

install:
	@bash scripts/install.sh

diff:
	@bash scripts/diff.sh

lsi:
	@bash scripts/ai-instances.sh

-include Makefile.local
