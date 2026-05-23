#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work="$(mktemp -d /tmp/nix-cage-launchers.XXXXXX)"
trap 'rm -rf "$work"' EXIT

# direct launcher executes the command via bash -c
out="$("$root/nix-cage" --launcher direct --command 'echo direct-ok')"
[[ "$out" == "direct-ok" ]] || { echo "direct launcher failed: '$out'"; exit 1; }
echo "direct launcher executes: ok"

# argparse rejects unknown launchers
ec=0
"$root/nix-cage" --launcher bogus --command 'true' 2>/dev/null || ec=$?
[[ $ec -ne 0 ]] || { echo "bogus launcher should fail"; exit 1; }
echo "invalid launcher rejected: ok"

# Auto-detection: flake.nix → nix-develop, devshell attrs reach --command env
flake_dir="$work/flake"
mkdir -p "$flake_dir"
cat > "$flake_dir/flake.nix" <<EOF
{
  inputs.nix-cage.url = "path:$root";
  outputs = { nix-cage, ... }: let
    pkgs = nix-cage.inputs.nixpkgs.legacyPackages.x86_64-linux;
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      NIX_CAGE_LAUNCHER_PROBE = "develop";
    };
  };
}
EOF
out="$(cd "$flake_dir" && "$root/nix-cage" "$root:ro" --command 'printenv NIX_CAGE_LAUNCHER_PROBE')"
[[ "$out" == "develop" ]] || { echo "nix-develop auto-detect failed: '$out'"; exit 1; }
echo "nix-develop auto-detect + execute: ok"

# Auto-detection: shell.nix → nix-shell
shell_dir="$work/shell"
mkdir -p "$shell_dir"
cat > "$shell_dir/shell.nix" <<EOF
let nix-cage = builtins.getFlake "path:$root";
    pkgs = nix-cage.inputs.nixpkgs.legacyPackages.x86_64-linux;
in pkgs.mkShell {
  NIX_CAGE_LAUNCHER_PROBE = "shell";
}
EOF
out="$(cd "$shell_dir" && "$root/nix-cage" "$root:ro" --command 'printenv NIX_CAGE_LAUNCHER_PROBE')"
[[ "$out" == "shell" ]] || { echo "nix-shell auto-detect failed: '$out'"; exit 1; }
echo "nix-shell auto-detect + execute: ok"
