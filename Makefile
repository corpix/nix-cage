.DEFAULT_GOAL := all

root           = $(shell git rev-parse --show-toplevel)
version        = $(shell git rev-parse --short HEAD)
scripts        = $(root)/scripts
build          = $(root)/build
builder        = sudo PATH=$(PATH) $(scripts)/build
gpg_key_id     = 650177753CFC13FA9490ED30887A0D14C7C55BD6
gh_user        = corpix
gh_repo        = devcage
image_uri      = $(gh_user).github.io/devcage

include */build.mk

.PHONY: all
all: build

.PHONY: build
build:: $(build)

$(build):
	mkdir -p "$(build)"

.PHONY: clean
clean:
	rm -rf $(build)
	rm -rf .acbuild

# .PHONY: sign
# sign: $(container)
# 	gpg2                                \
# 		--default-key $(gpg_key_id) \
# 		--armor                     \
# 		--output $(container).asc   \
# 		--detach-sig $(container)
# 	gpg2                                \
# 		--default-key $(gpg_key_id) \
# 		--verify $(container).asc   \
# 		$(container)

.PHONY: tag
tag:
	git tag $(version)

.PHONY: release
release:
	[ ! -z $(GITHUB_TOKEN) ]
	github-release release \
		-u $(gh_user)  \
		-r $(gh_repo)  \
		-t $(version)

# .PHONY: upload
# upload: release
# 	[ ! -z $(GITHUB_TOKEN) ]
# 	github-release upload                         \
# 		-u $(gh_user)                         \
# 		-r $(gh_repo)                         \
# 		-t $(version)                         \
# 		-n $(shell basename $(container))     \
# 		-f $(container)
# 	github-release upload                         \
# 		-u $(gh_user)                         \
# 		-r $(gh_repo)                         \
# 		-t $(version)                         \
# 		-n $(shell basename $(container)).asc \
# 		-f $(container).asc

# .PHONY: test
# test: $(container)
# 	sudo rkt --insecure-options=all \
# 		run $(container)        \
# 		--exec=/bin/sh --       \
# 		-c 'echo 1'
