#!/usr/bin/env bash
set -e
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)

   curl -Ls                                                                           \
        https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init \
        > /usr/bin/rustup-init
   chmod +x /usr/bin/rustup-init
   echo 'export PATH=/home/user/.cargo/bin:\$PATH' >> /etc/profile.d/path.sh
   chmod +x /etc/profile.d/path.sh

   dnf clean all
   rm -rf /tmp/*
"
