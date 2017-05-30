.PHONY: base
base: $(build)
	$(builder)                                            \
		$(image_uri)/base                             \
		$(version)                                    \
		$(root)/base/builder.aci.sh                   \
		$(base)                                       \
		--base=corpix.github.io/fedora:25-1.3.1496168457

build:: base
