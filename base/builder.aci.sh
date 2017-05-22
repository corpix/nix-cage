#!/usr/bin/env bash
source "$(git rev-parse --show-toplevel)"/scripts/env

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ac run -- sh -c "
   set -e
   mkdir -p /home/user
   $(proxy)
   dnf group install -y --best 'development tools'
   dnf install -y --best                             \
       emacs-nox make tmux tree mc htop iotop zsh jq \
       unzip bsdtar sudo xz tar p7zip                \
       openssh-clients openssh-server                \
       bind-utils iputils iproute nmap git           \
       aspell aspell-en glibc-locale-source          \
       'dnf-command(copr)'
   mkdir /etc/emacs
   dnf clean all
   rm -rf /tmp/*
   echo 'nameserver 208.67.222.222' >  /etc/resolv.conf
   echo 'nameserver 208.67.220.220' >> /etc/resolv.conf
   echo 'LANG=\"en_US.UTF-8\"'      >  /etc/locale.conf
   localedef -v -c -i en_US -f UTF-8 en_US.UTF-8
"

ac set-working-directory /home/user

ac mount add projects     /home/user/Projects
ac mount add emacs        /home/user/.emacs.d

ac environment add LANG       en_US.UTF-8
ac environment add PATH       /home/user/Projects/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ac environment add TERM       screen-256color
ac environment add DEMOTE_UID 1000
ac environment add DEMOTE_GID 1000

ac copy "$toolbox"/execute/demote /usr/bin/demote
ac copy "$script_dir"/entrypoint  /entrypoint

ac set-exec -- /entrypoint
