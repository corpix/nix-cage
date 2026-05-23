#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work="$(mktemp -d /tmp/nix-cage-merge.XXXXXX)"
trap 'rm -rf "$work"' EXIT

parent="$work/parent"
child="$parent/child"
mkdir -p "$child"

# Default expand mode: parent and child both contribute, lists are unioned.
cat > "$parent/nix-cage.json" <<'EOF'
{ "environment": { "PARENT_VAR": "p" }, "mounts": { "rw": [["/tmp/from-parent", "/tmp/from-parent"]] } }
EOF
cat > "$child/nix-cage.json" <<'EOF'
{ "environment": { "CHILD_VAR": "c" }, "mounts": { "rw": [["/tmp/from-child", "/tmp/from-child"]] } }
EOF

cfg="$(cd "$child" && "$root/nix-cage" --show-config)"
echo "$cfg" | jq -e '.environment.PARENT_VAR == "p"' >/dev/null \
  || { echo "expand: parent env missing"; exit 1; }
echo "$cfg" | jq -e '.environment.CHILD_VAR == "c"' >/dev/null \
  || { echo "expand: child env missing"; exit 1; }
echo "$cfg" | jq -e '.mounts.rw | map(.[0]) | (index("/tmp/from-parent") != null) and (index("/tmp/from-child") != null)' >/dev/null \
  || { echo "expand: rw not unioned"; exit 1; }
echo "expand mode (default) unions parent + child: ok"

# Replace mode at child wipes inherited lists (incl. the default '.' rw mount).
cat > "$child/nix-cage.json" <<'EOF'
{ "mode": "replace", "mounts": { "rw": [["/tmp/only-child", "/tmp/only-child"]] } }
EOF
cfg="$(cd "$child" && "$root/nix-cage" --show-config)"
echo "$cfg" | jq -e '.mounts.rw | map(.[0]) == ["/tmp/only-child"]' >/dev/null \
  || { echo "replace: rw should equal exactly [/tmp/only-child], got $(echo "$cfg" | jq .mounts.rw)"; exit 1; }
echo "replace mode wipes lower layer: ok"

# Per-section mode override: global expand, mounts.mode=replace.
cat > "$child/nix-cage.json" <<'EOF'
{
  "mode": "expand",
  "environment": { "CHILD_VAR": "c" },
  "mounts": { "mode": "replace", "rw": [["/tmp/section-only", "/tmp/section-only"]] }
}
EOF
cfg="$(cd "$child" && "$root/nix-cage" --show-config)"
echo "$cfg" | jq -e '.environment.PARENT_VAR == "p" and .environment.CHILD_VAR == "c"' >/dev/null \
  || { echo "per-section: env should still expand"; exit 1; }
echo "$cfg" | jq -e '.mounts.rw | map(.[0]) | index("/tmp/from-parent") == null' >/dev/null \
  || { echo "per-section: rw should be replaced"; exit 1; }
echo "per-section mode override: ok"
