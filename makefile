.DEFAULT_GOAL := all

root = $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))

##

define assert # assert cmd selector operator sample
$(1) | jq 'select($(2) $(3) $(4) | not) | [ "not matched", "operator:", "$(3)", "actual $(2):", $(2), "want:", $(4) ] | halt_error(1)'
echo '$(2) $(3) $(4)'
endef

define nix-cage
cd /tmp && $(root)/nix-cage $(1)
endef

.PHONY: all
all: # does nothing

.PHONY: build
build: # build package
	nix-build .

.PHONY: test
test: build # runs integration tests
	$(info == basic tests)

	@mkdir -p /tmp/foo

	@$(call nix-cage,--show-config > /dev/null)
	@$(call assert,$(call nix-cage,--show-config),.mounts.rw[0][0],==,"/tmp")
	@$(call assert,$(call nix-cage,-C /tmp/foo --show-config),.mounts.rw[0][0],==,"/tmp/foo")

	@rmdir /tmp/foo

	$(info == sandbox tests)

	echo '{}' > /tmp/emptyjson

	$(root)/result/bin/nix-cage --config /var/nonexistent --command 'ls'
	$(root)/result/bin/nix-cage --config /tmp/emptyjson   --command 'ls'

	@rm -f /tmp/emptyjson
##

.PHONY: help
help: # print defined targets and their comments
	@grep -Po '^[a-zA-Z%_/\-\s]+:+(\s.*$$|$$)' $(MAKEFILE_LIST)  \
		| sort                                                   \
		| sed 's|:.*#|#|;s|#\s*|#|'                              \
		| column -t -s '#' -o ' | '
