fedora_version ?= 25-1499038497

.PHONY: base
base: $(build)
	$(builder)                                            \
		$(image_uri)/base                             \
		$(version)                                    \
		$(root)/base/builder.aci.sh                   \
		$(base)                                       \
		--base=corpix.github.io/fedora:$(fedora_version)

build:: base
