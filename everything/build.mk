.PHONY: everything
everything: $(build)
	$(builder)                                               \
		$(image_uri)/everything                          \
		$(version)                                       \
		$(root)/everything/builder.aci.sh                \
		$(build)/everything-$(version)-$(os)-$(arch).aci \
		--base=$(base)
	version=$(version)                                       \
		$(toolbox)/template/format-environ               \
		--file $(root)/everything/everything.json.tpl    \
		--out $(root)/everything/everything.json

build:: everything
