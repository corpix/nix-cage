#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

empty_json="$(mktemp /tmp/nix-cage-empty-json.XXXXXX)"
trap 'rm -f "$empty_json"' EXIT

printf '%s\n' '{}' > "$empty_json"

"$root/result/bin/nix-cage" --config /var/nonexistent --command 'ls'
"$root/result/bin/nix-cage" --config "$empty_json" --command 'ls'
