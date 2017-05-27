.PHONY: go
go: $(build)
	$(builder)                                       \
		$(image_uri)/go                          \
		$(version)                               \
		$(root)/go/builder.aci.sh                \
		$(build)/go-$(version)-$(os)-$(arch).aci \
		--base=$(base)
	version=$(version)                               \
		$(toolbox)/template/format-environ       \
		--file $(root)/go/go.json.tpl            \
		--out $(root)/go/go.json

build:: go
