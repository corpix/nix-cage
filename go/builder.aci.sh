#!/usr/bin/env bash
set -e
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)
   dnf install -y --best bison golang
   dnf clean all
   rm -rf /tmp/*
"

ac environment add GOPATH /home/user/Projects
ac environment add GOROOT /usr/lib/golang
ac copy "$root"/go/gvm-init /usr/bin/gvm-init
ac copy "$root"/go/gvm-env  /etc/profile.d/gvm-env.sh
