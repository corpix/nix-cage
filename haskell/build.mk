.PHONY: haskell
haskell: $(build)
	$(builder)                                            \
		$(image_uri)/haskell                          \
		$(version)                                    \
		$(root)/haskell/builder.aci.sh                \
		$(build)/haskell-$(version)-$(os)-$(arch).aci \
		--base=$(base)
	version=$(version)                                    \
		$(toolbox)/template/format-environ            \
		--file $(root)/haskell/haskell.json.tpl       \
		--out $(root)/haskell/haskell.json

build:: haskell
