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

write_nix_cage_flake() {
  local dir="$1"

  mkdir -p "$dir/data"
  cat > "$dir/flake.nix" <<EOF
{
  inputs.nix-cage.url = "path:$root";
  outputs = { nix-cage, ... }: {
    nixCageConfigurations.default = nix-cage.lib.mkNixCageConfiguration {
      modules = [{
        mounts.rw = [{ source = "./data"; target = "~/.nix-cage-test-data"; create = true; }];
        environment.FOO = "flake";
        arguments.nixDevelop = [ "--impure" ];
        launcher = "direct";
        command = "echo flake";
      }];
    };
  };
}
EOF
}

write_ordinary_flake() {
  local dir="$1"

  cat > "$dir/flake.nix" <<EOF
{
  inputs.nix-cage.url = "path:$root";
  outputs = { nix-cage, ... }: {
    packages.x86_64-linux.default = nix-cage.packages.x86_64-linux.default;
  };
}
EOF
}

write_invalid_flake() {
  local dir="$1"

  cat > "$dir/flake.nix" <<'EOF'
{
  outputs = { ... }: {
    nixCageConfigurations.default = "not-a-configuration";
  };
}
EOF
}

write_sandboxed_shell_flake() {
  local dir="$1"

  cat > "$dir/flake.nix" <<EOF
{
  inputs.nix-cage.url = "path:$root";
  outputs = { nix-cage, ... }: {
    devShells.x86_64-linux.default = nix-cage.lib.mkSandboxedDevShell {
      system = "x86_64-linux";
      modules = [{
        environment.FOO = "shell";
        launcher = "nix-develop";
      }];
    };
  };
}
EOF
}

flake_dir="$(mktemp -d /tmp/nix-cage-flake-config.XXXXXX)"
ordinary_dir="$(mktemp -d /tmp/nix-cage-ordinary-flake.XXXXXX)"
invalid_dir="$(mktemp -d /tmp/nix-cage-invalid-flake.XXXXXX)"
shell_dir="$(mktemp -d /tmp/nix-cage-sandboxed-shell.XXXXXX)"
trap 'rm -rf "$flake_dir" "$ordinary_dir" "$invalid_dir" "$shell_dir"' EXIT

write_nix_cage_flake "$flake_dir"

assert_json "'$root/nix-cage' -C '$flake_dir' --show-config" ".environment.FOO" "==" '"flake"'
assert_json "'$root/nix-cage' -C '$flake_dir' --show-config" ".mounts.rw[0][0]" "==" "\"$flake_dir/data\""
assert_json "'$root/nix-cage' -C '$flake_dir' --show-config" ".mounts.rw[0][2]" "==" '"d"'
"$root/nix-cage" -C "$flake_dir" --show-config | jq -e '.arguments["nix-develop"][0] == "--impure"' > /dev/null
assert_json "'$root/nix-cage' -C '$flake_dir' --show-config" ".launcher" "==" '"direct"'
assert_json "'$root/nix-cage' -C '$flake_dir' --show-config" ".arguments.command" "==" '"echo flake"'

printf '%s\n' '{"environment":{"FOO":"json"}}' > "$flake_dir/nix-cage.json"
assert_json "'$root/nix-cage' -C '$flake_dir' --show-config" ".environment.FOO" "==" '"flake"'
assert_json "'$root/nix-cage' -C '$flake_dir' --config '$flake_dir/missing.json' --show-config" ".environment.FOO" "==" 'null'

write_ordinary_flake "$ordinary_dir"
assert_json "'$root/nix-cage' -C '$ordinary_dir' --show-config" ".environment.FOO" "==" 'null'

write_invalid_flake "$invalid_dir"
if "$root/nix-cage" -C "$invalid_dir" --show-config > /dev/null 2>&1; then
  echo "invalid nixCageConfigurations.default unexpectedly succeeded" >&2
  exit 1
fi

write_sandboxed_shell_flake "$shell_dir"
nix eval --impure --no-write-lock-file --raw "path:$shell_dir#devShells.x86_64-linux.default.shellHook" 2> /dev/null \
  | grep -F 'nix-cage --config' > /dev/null
nix eval --impure --no-write-lock-file --raw "path:$shell_dir#devShells.x86_64-linux.default.shellHook" 2> /dev/null \
  | grep -F -- '--launcher direct' > /dev/null
