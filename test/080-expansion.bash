#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work="$(mktemp -d /tmp/nix-cage-expansion.XXXXXX)"
trap 'rm -rf "$work"' EXIT

export HOME="$work/home"
mkdir -p "$HOME"

# ${HOME} expands in mount paths and environment values.
cat > "$work/nix-cage.json" <<'EOF'
{
  "mounts": { "rw": [["${HOME}/data", "${HOME}/data"]] },
  "environment": { "DATA_PATH": "${HOME}/data" }
}
EOF
cfg="$(cd "$work" && "$root/nix-cage" --show-config)"
echo "$cfg" | jq -e --arg p "$HOME/data" '.mounts.rw | map(.[0]) | index($p) != null' >/dev/null \
  || { echo "mount \${HOME} not expanded"; exit 1; }
echo "$cfg" | jq -e --arg p "$HOME/data" '.environment.DATA_PATH == $p' >/dev/null \
  || { echo "env \${HOME} not expanded"; exit 1; }
echo "\${HOME} expansion: ok"

# ~ expansion in mount paths.
cat > "$work/nix-cage.json" <<'EOF'
{ "mounts": { "rw": [["~/tildedata", "~/tildedata"]] } }
EOF
cfg="$(cd "$work" && "$root/nix-cage" --show-config)"
echo "$cfg" | jq -e --arg p "$HOME/tildedata" '.mounts.rw | map(.[0]) | index($p) != null' >/dev/null \
  || { echo "~ in mount path not expanded"; exit 1; }
echo "~ expansion: ok"
