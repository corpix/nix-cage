.PHONY: base
base: $(build)
	$(builder)                                            \
		$(image_uri)/base                             \
		$(version)                                    \
		$(root)/base/builder.aci.sh                   \
		$(base)                                       \
		--base=corpix.github.io/fedora:1.1-c9c3529

build:: base
