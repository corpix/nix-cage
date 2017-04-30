.PHONY: base
base: $(build)
	$(builder)                                            \
		base                                          \
		$(version)                                    \
		$(root)/base/builder.aci.sh                   \
		$(build)/base-$(version).aci                  \
		--base=corpix.github.io/fedora:25-1.3.547c52e

build:: base
