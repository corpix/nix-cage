base: $(build)
	$(builder) base $(version) $(root)/base/builder.aci.sh $(build)/base.aci

build:: base
