.DEFAULT_GOAL := all

root           = $(shell git rev-parse --show-toplevel)
version       ?= 1.0-$(shell git rev-parse --short HEAD)
os             = linux
arch           = amd64
scripts        = $(root)/scripts
build          = $(root)/build
gpg_key_id     = 650177753CFC13FA9490ED30887A0D14C7C55BD6
gh_user        = corpix
gh_repo        = devcage
image_uri      = $(gh_user).github.io/devcage
base           = $(build)/base-$(version)-$(os)-$(arch).aci
toolbox        = $(scripts)/toolbox
builder        = sudo              \
	PATH=$(PATH)               \
	version=$(version)         \
	os=$(os)                   \
	arch=$(arch)               \
	scripts=$(scripts)         \
	toolbox=$(toolbox)         \
	http_proxy=$(http_proxy)   \
	https_proxy=$(https_proxy) \
	HTTP_PROXY=$(HTTP_PROXY)   \
	HTTPS_PROXY=$(HTTPS_PROXY) \
	$(scripts)/build

.PHONY: build
build:: $(build) $(toolbox)
	@if [ "$(shell git ls-files -m | wc -l)" != 0 ];                      \
	then                                                                  \
		echo "You have not commited your changes.";                   \
		echo "This will have effect on a version of the containers."; \
		echo "Please commit your changes.";                           \
		echo;                                                         \
		exit 1;                                                       \
	fi 1>&2

include base/build.mk
include rust/build.mk
include haskell/build.mk
include go/build.mk
include javascript/build.mk
include everything/build.mk

.PHONY: all
all: build test

$(build):
	@mkdir -p "$(build)"

$(toolbox):
	git submodule update --init --recursive

.PHONY: README.md
README.md: $(toolbox)
	version=$(version)                         \
		$(toolbox)/template/format-environ \
			--file README.tpl.md       \
			--out README.md

.PHONY: sign
sign: $(build)
	@find $(build) -type f -name '*.aci'                 \
		| xargs -I{} bash -c '                       \
			set -e;                              \
			gpg2                                 \
				--default-key $(gpg_key_id)  \
				--armor                      \
				--output {}.asc              \
				--detach-sig {}              \
			&& gpg2                              \
				--default-key $(gpg_key_id)  \
				--verify {}.asc              \
				{}                           \
		'

.PHONY: tag
tag: README.md
	@git tag $(version)

.PHONY: release
release:
	@if [ -z $(GITHUB_TOKEN) ];                                 \
	then                                                        \
		echo "Set github token with environment variable:"; \
		echo "    GITHUB_TOKEN";                            \
		exit 1;                                             \
	fi 1>&2

	@git push origin --tags
	@github-release release \
		-u $(gh_user)  \
		-r $(gh_repo)  \
		-t $(version)

.PHONY: upload
upload: $(build)
	@if [ -z $(GITHUB_TOKEN) ];                                 \
	then                                                        \
		echo "Set github token with environment variable:"; \
		echo "    GITHUB_TOKEN";                            \
		exit 1;                                             \
	fi 1>&2

	@find $(build) -type f -name '*.aci'              \
		| xargs -I{} bash -c '                    \
			set -e;                           \
			if [ ! -e {} ];                   \
			then                              \
				echo "{} not exists";     \
				exit 1;                   \
			fi 1>&2;                          \
			if [ ! -e {}.asc ];               \
			then                              \
				echo "{}.asc not exists"; \
				exit 1;                   \
			fi 1>&2;                          \
			github-release upload             \
				-u $(gh_user)             \
				-r $(gh_repo)             \
				-t $(version)             \
				-n $$(basename {})        \
				-f {};                    \
			github-release upload             \
				-u $(gh_user)             \
				-r $(gh_repo)             \
				-t $(version)             \
				-n $$(basename {}).asc    \
				-f {}.asc;                \
		'

.PHONY: test
test:
	@if [ "$(shell ls $(build)/*.aci | wc -l)" = 0 ];  \
	then                                               \
		echo "There is no containers in $(build)"; \
		exit 1;                                    \
	fi 1>&2

	@find $(build) -type f -name '*.aci'            \
		| xargs -I{} bash -c '                  \
			set -e;                         \
			sudo rkt --insecure-options=all \
				run {}                  \
				--exec=/bin/sh --       \
				-c "echo 1"             \
		'

.PHONY: clean
clean:
	rm -rf $(build)
	sudo rm -rf .acbuild
