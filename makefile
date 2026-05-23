.DEFAULT_GOAL := all

.PHONY: all
all: # does nothing

.PHONY: build
build: # build package
	nix build

.PHONY: test
test: build # runs integration tests
	@set -e; for test in test/*.bash; do echo "== $$test"; bash "$$test"; done
##

.PHONY: help
help: # print defined targets and their comments
	@grep -Po '^[a-zA-Z%_/\-\s]+:+(\s.*$$|$$)' $(MAKEFILE_LIST)  \
		| sort                                                   \
		| sed 's|:.*#|#|;s|#\s*|#|'                              \
		| column -t -s '#' -o ' | '
