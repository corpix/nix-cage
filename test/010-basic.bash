#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

assert_json() {
  local command="$1"
  local selector="$2"
  local operator="$3"
  local want="$4"

  eval "$command" | jq "select(${selector} ${operator} ${want} | not) | [ \"not matched\", \"operator:\", \"${operator}\", \"actual ${selector}:\", ${selector}, \"want:\", ${want} ] | halt_error(1)"
  echo "${selector} ${operator} ${want}"
}

tmpdir="$(mktemp -d /tmp/nix-cage-basic.XXXXXX)"
trap 'rm -rf "$tmpdir"' EXIT

cd /tmp
"$root/nix-cage" --show-config > /dev/null

assert_json "cd /tmp && '$root/nix-cage' --show-config" ".mounts.rw[0][0]" "==" '"/tmp"'
assert_json "'$root/nix-cage' -C '$tmpdir' --show-config" ".mounts.rw[0][0]" "==" "\"$tmpdir\""
