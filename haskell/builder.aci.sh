#!/usr/bin/env bash
set -e
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)
   dnf copr enable -y petersen/stack
   dnf install -y --best ghc ghc-devel cabal-install stack
   stack upgrade
   dnf clean all
   rm -rf /tmp/*
"

ac copy "$root"/haskell/stack-env  /etc/profile.d/stack-env.sh
