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

   dnf clean all
   rm -rf /tmp/*
"

ac environment add PATH /home/user/.cargo/bin:/home/user/Projects/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
