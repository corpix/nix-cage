.PHONY: go
go: $(build)
	$(builder)                                       \
		$(image_uri)/go                          \
		$(version)                               \
		$(root)/go/builder.aci.sh                \
		$(build)/go-$(version)-$(os)-$(arch).aci \
		--base=$(base)

build:: go
