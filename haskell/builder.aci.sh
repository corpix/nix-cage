#!/usr/bin/env bash
set -e
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)
   dnf copr enable -y petersen/stack
   dnf install -y --best ghc ghc-devel cabal-install stack
   stack upgrade
   echo 'export PATH=/home/user/.local/bin:\$PATH' >> /etc/profile.d/path.sh
   chmod +x /etc/profile.d/path.sh
   dnf clean all
   rm -rf /tmp/*
"
