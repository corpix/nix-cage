.PHONY: java
java: $(build)
	$(builder)                                         \
		$(image_uri)/java                          \
		$(version)                                 \
		$(root)/java/builder.aci.sh                \
		$(build)/java-$(version)-$(os)-$(arch).aci \
		--base=$(base_uri)
	version=$(version)                                 \
		$(toolbox)/template/format-environ         \
		--file $(root)/java/java.json.tpl          \
		--out $(root)/java/java.json

build:: java
