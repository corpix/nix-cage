#!/usr/bin/env bash
set -e
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)
   sudo -E dnf install -y --best golang
"

ac environment add GOPATH /home/user/Projects
