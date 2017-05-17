#!/usr/bin/env bash
source "$(git rev-parse --show-toplevel)"/scripts/env

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ac run -- sh -c "
   set -e
   mkdir -p /home/user
   $(proxy)
   dnf group install -y --best 'development tools'
   dnf install -y --best                             \
       emacs-nox make tmux tree mc htop iotop zsh    \
       unzip bsdtar sudo xz tar p7zip                \
       openssh-clients openssh-server                \
       'dnf-command(copr)'
   mkdir /etc/emacs
"

ac set-working-directory /home/user

ac mount add projects     /home/user/Projects
ac mount add emacs        /home/user/.emacs.d

ac environment add PATH       /home/user/Projects/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ac environment add TERM       screen-256color
ac environment add DEMOTE_UID 1000
ac environment add DEMOTE_GID 1000

ac copy "$toolbox"/execute/demote /usr/bin/demote
ac copy "$script_dir"/entrypoint  /entrypoint

ac set-exec -- /entrypoint
