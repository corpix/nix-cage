.PHONY: rust
rust: $(build)
	$(builder)                                         \
		$(image_uri)/rust                          \
		$(version)                                 \
		$(root)/rust/builder.aci.sh                \
		$(build)/rust-$(version)-$(os)-$(arch).aci \
		--base=$(base)

build:: rust
