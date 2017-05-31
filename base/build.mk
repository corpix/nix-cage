.PHONY: base
base: $(build)
	$(builder)                                            \
		$(image_uri)/base                             \
		$(version)                                    \
		$(root)/base/builder.aci.sh                   \
		$(base)                                       \
		--base=corpix.github.io/fedora:1.9-a9c8d5b

build:: base
