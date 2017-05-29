#!/usr/bin/env bash
set -e
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)
   dnf install -y --best nodejs nodejs-devel npm
   npm i -g tern
   dnf clean all
   rm -rf /tmp/*
"
