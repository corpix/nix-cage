#!/usr/bin/env bash
set -e
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)
   dnf install -y --best nodejs nodejs-devel npm
   dnf clean all
   rm -rf /tmp/*
"
ac copy "$root"/javascript/nvm-init /usr/bin/nvm-init
ac copy "$root"/javascript/nvm-env  /etc/profile.d/nvm-env.sh
