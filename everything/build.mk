.PHONY: everything
everything: $(build)
	$(builder)                                               \
		$(image_uri)/everything                          \
		$(version)                                       \
		$(root)/everything/builder.aci.sh                \
		$(build)/everything-$(version)-$(os)-$(arch).aci \
		--base=$(base)

build:: everything
