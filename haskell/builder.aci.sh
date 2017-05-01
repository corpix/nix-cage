#!/usr/bin/env bash
set -e
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)
   sudo dnf copr enable -y petersen/stack
   sudo -E dnf install -y --best ghc ghc-devel cabal-install stack
   sudo stack upgrade
   stack setup
"
