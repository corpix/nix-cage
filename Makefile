.DEFAULT_GOAL := all

tests = $(wildcard test/*)

.PHONY: all
all:

.PHONY: build
build:
	nix-build .

.PHONY: test
test: build $(tests)

.PHONY: $(tests)
$(tests):
	$(info == $@)
	@bash ./$@
