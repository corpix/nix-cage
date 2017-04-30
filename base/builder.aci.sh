#!/usr/bin/env bash
source "$(git rev-parse --show-toplevel)"/scripts/env

ac run -- sh -c "
   set -e
   $(proxy)
   dnf group install -y --best 'development tools'
   dnf install -y --best emacs make tmux tree mc htop iotop zsh unzip bsdtar sudo
   useradd -md /home/user -U user
   usermod -p '*' user
   echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
"

ac set-user user
ac set-working-directory /home/user

ac mount add projects /home/user/Projects
ac mount add emacs    /home/user/.emacs.d

ac environment add PATH /home/user/Projects/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
