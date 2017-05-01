.PHONY: javascript
javascript: $(build)
	$(builder)                                               \
		$(image_uri)/javascript                          \
		$(version)                                       \
		$(root)/javascript/builder.aci.sh                \
		$(build)/javascript-$(version)-$(os)-$(arch).aci \
		--base=$(base)

build:: javascript
