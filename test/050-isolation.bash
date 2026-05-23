#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work="$(mktemp -d /tmp/nix-cage-isolation.XXXXXX)"
trap 'rm -rf "$work"' EXIT

# --unshare-uts + --hostname localhost actually applied
out="$("$root/nix-cage" -C "$work" --launcher direct --command 'hostname')"
[[ "$out" == "localhost" ]] || { echo "hostname expected 'localhost', got '$out'"; exit 1; }
echo "hostname overridden: ok"

# /dev is dev-bound: /dev/null is a character device
out="$("$root/nix-cage" -C "$work" --launcher direct --command 'stat -c %F /dev/null')"
[[ "$out" == "character special file" ]] || { echo "/dev/null wrong: '$out'"; exit 1; }
echo "/dev mount: ok"

# ro mount: writing under / (default ro) fails
ec=0
"$root/nix-cage" -C "$work" --launcher direct --command 'touch /nix-cage-ro-test 2>/dev/null' || ec=$?
[[ $ec -ne 0 ]] || { echo "ro / accepted a write"; exit 1; }
echo "ro mount blocks writes: ok"

# rw mount: writes persist on host
rwdir="$work/rwdata"
mkdir -p "$rwdir"
"$root/nix-cage" -C "$work" "$rwdir" --launcher direct --command "touch $rwdir/inside-marker"
[[ -f "$rwdir/inside-marker" ]] || { echo "rw mount write did not persist"; exit 1; }
echo "rw mount persists: ok"

# tmpfs (default for /tmp): writes inside don't leak to host
"$root/nix-cage" -C "$work" --launcher direct \
  --command 'touch /tmp/nix-cage-tmpfs-only && test -f /tmp/nix-cage-tmpfs-only'
[[ ! -e /tmp/nix-cage-tmpfs-only ]] || { echo "tmpfs leaked to host /tmp"; exit 1; }
echo "tmpfs isolates from host: ok"
