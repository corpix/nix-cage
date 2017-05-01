.PHONY: haskell
haskell: $(build)
	$(builder)                                            \
		$(image_uri)/haskell                          \
		$(version)                                    \
		$(root)/haskell/builder.aci.sh                \
		$(build)/haskell-$(version)-$(os)-$(arch).aci \
		--base=$(base)

build:: haskell
