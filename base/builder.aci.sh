#!/usr/bin/env bash
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)
   dnf group install -y --best 'development tools'
   dnf install -y --best emacs make tmux tree mc htop iotop zsh unzip bsdtar
   useradd -md /home/user -U user
   usermod -p '*' user
"

ac set-user user
ac set-working-directory /home/user
