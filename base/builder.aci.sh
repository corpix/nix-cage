#!/usr/bin/env bash
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)
   dnf group install -y --best 'development tools'
   dnf install -y --best emacs vim make tmux tree hexdump mc htop iotop zsh unzip bsdtar
"
