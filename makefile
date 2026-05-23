.DEFAULT_GOAL := all

.PHONY: all
all: # does nothing

.PHONY: build
build: # build package
	nix build

.PHONY: test
test: # runs NixOS VM integration tests
	@arch=$$(nix eval --raw --impure --expr builtins.currentSystem); \
	nix build -L --print-out-paths --no-link ".#nixosTests.$$arch.default"

.PHONY: release
release: # release new version, usage: make release [major=N] [minor=N]
	@set -e; \
	last_tag=$$(git describe --tags --abbrev=0 2>/dev/null || true); \
	last_version=$$(echo "$$last_tag" | sed 's/-.*//'); \
	last_major=$$(echo "$$last_version" | awk -F. '{print $$1}'); \
	last_minor=$$(echo "$$last_version" | awk -F. '{print $$2}'); \
	major="$(major)"; minor="$(minor)"; \
	[ -z "$$major" ] && major=$${last_major:-0}; \
	[ -z "$$minor" ] && minor=$${last_minor:-0}; \
	if [ -n "$(major)" ] || [ -n "$(minor)" ] || [ -z "$$last_tag" ]; then \
		patch=0; \
	else \
		patch=$$(git rev-list "$$last_tag"..HEAD --count); \
	fi; \
	version="$$major.$$minor.$$patch"; \
	echo "releasing v$$version"; \
	sed -i "s/version = \".*\";/version = \"$$version\";/" nix/package.nix; \
	git add nix/package.nix; \
	git commit -m "v$$version"; \
	git tag "v$$version"

##

.PHONY: help
help: # print defined targets and their comments
	@grep -Po '^[a-zA-Z%_/\-\s]+:+(\s.*$$|$$)' $(MAKEFILE_LIST)  \
		| sort                                                   \
		| sed 's|:.*#|#|;s|#\s*|#|'                              \
		| column -t -s '#' -o ' | '
