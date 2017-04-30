.PHONY: base
base: $(build)
	$(builder)                                            \
		$(image_uri)/base                             \
		$(version)                                    \
		$(root)/base/builder.aci.sh                   \
		$(build)/base-$(version)-$(os)-$(arch).aci    \
		--base=corpix.github.io/fedora:25-1.3.547c52e

build:: base
