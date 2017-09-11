.PHONY: clojure
clojure: $(build)
	$(builder)                                            \
		$(image_uri)/clojure                          \
		$(version)                                    \
		$(root)/clojure/builder.aci.sh                \
		$(build)/clojure-$(version)-$(os)-$(arch).aci \
		--base=$(base_uri)
	version=$(version)                                    \
		$(toolbox)/template/format-environ            \
		--file $(root)/clojure/clojure.json.tpl       \
		--out $(root)/clojure/clojure.json

build:: clojure
