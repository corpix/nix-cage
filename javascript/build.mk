.PHONY: javascript
javascript: $(build)
	$(builder)                                               \
		$(image_uri)/javascript                          \
		$(version)                                       \
		$(root)/javascript/builder.aci.sh                \
		$(build)/javascript-$(version)-$(os)-$(arch).aci \
		--base=$(base)
	version=$(version)                                       \
		$(toolbox)/template/format-environ               \
		--file $(root)/javascript/javascript.json.tpl    \
		--out $(root)/javascript/javascript.json

build:: javascript
