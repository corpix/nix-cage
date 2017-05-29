.PHONY: rust
rust: $(build)
	$(builder)                                         \
		$(image_uri)/rust                          \
		$(version)                                 \
		$(root)/rust/builder.aci.sh                \
		$(build)/rust-$(version)-$(os)-$(arch).aci \
		--base=$(base_uri)
	version=$(version)                                 \
		$(toolbox)/template/format-environ         \
		--file $(root)/rust/rust.json.tpl          \
		--out $(root)/rust/rust.json

build:: rust
