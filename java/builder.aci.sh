#!/usr/bin/env bash
set -e
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)
   dnf install -y --best \
       java-1.8.0-openjdk-headless
   dnf clean all
   rm -rf /tmp/*
"
