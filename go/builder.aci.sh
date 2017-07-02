#!/usr/bin/env bash
set -e
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)
   # ncurses-compat-libs for gomobile
   dnf install -y --best \
       bison golang      \
       ncurses-compat-libs
   dnf clean all
   rm -rf /tmp/*
"

ac environment add GOPATH /home/user/Projects
ac environment add GOROOT /usr/lib/golang
