#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work="$(mktemp -d /tmp/nix-cage-mount-suffix.XXXXXX)"
trap 'rm -rf "$work"' EXIT

cd "$work"

check_bucket() {
  local arg="$1" bucket="$2" path="$3"
  "$root/nix-cage" "$arg" --show-config \
    | jq -e --arg p "$path" ".mounts.${bucket} | map(.[0]) | index(\$p) != null" >/dev/null \
    || { echo "expected '$path' in mounts.${bucket} after '${arg}'"; exit 1; }
  echo "${arg} → ${bucket}: ok"
}

check_bucket "/tmp/sample"        rw    "/tmp/sample"
check_bucket "/tmp/sample:rw"     rw    "/tmp/sample"
check_bucket "/tmp/sample:ro"     ro    "/tmp/sample"
check_bucket "/tmp/sample:dev"    dev   "/tmp/sample"
check_bucket "/tmp/sample:tmpfs"  tmpfs "/tmp/sample"
