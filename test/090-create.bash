#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work="$(mktemp -d /tmp/nix-cage-create.XXXXXX)"
trap 'rm -rf "$work"' EXIT

target="$work/will-be-created/nested"

cat > "$work/nix-cage.json" <<EOF
{ "mounts": { "rw": [{ "source": "$target", "target": "$target", "create": true }] } }
EOF

[[ ! -e "$target" ]] || { echo "target should not exist yet"; exit 1; }
(cd "$work" && "$root/result/bin/nix-cage" --launcher direct --command 'true')
[[ -d "$target" ]] || { echo "create: true did not make the directory"; exit 1; }
echo "create:true makes the source directory: ok"
