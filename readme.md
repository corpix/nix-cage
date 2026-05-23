nix-cage
--------------

Sandboxed environments with `bwrap` and `nix` package manager.

## Requirements

- Python
- Bubblewrap
- Nix

## Basics

For basic usage there are 2 steps:

- create `flake.nix` or `shell.nix` with settings you need
- start `nix-cage`

When `flake.nix` is present in the working directory, `nix-cage` starts the
command with `nix develop`. Otherwise it falls back to `nix-shell` when
`shell.nix` is present, or to the configured shell command directly.

Example of `flake.nix`:

```nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python3
        ];
      };
    };
}
```

`flake.nix` may also provide nix-cage settings. When using the default
`nix-cage.json` config path, `nix-cage` reads
`nixCageConfigurations.default.config` from the current directory's flake and
merges it after discovered JSON config files:

```nix
{
  inputs.nix-cage.url = "github:corpix/nix-cage";

  outputs = { nix-cage, ... }: {
    nixCageConfigurations.default = nix-cage.lib.mkNixCageConfiguration {
      modules = [
        {
          mounts.rw = [
            "~/.emacs.d"
            {
              source = "./.config";
              target = "~/.config";
              create = true;
            }
          ];

          environment.FOO = "bar";

          arguments.bwrap = [ "--proc" "/proc" ];
          arguments.nixDevelop = [ "--impure" ];

          launcher = "direct";
          command = "bash";
        }
      ];
    };
  };
}
```

If `--config` points to a custom path, flake config is not loaded. Ordinary
flakes without `nixCageConfigurations.default` keep the default nix-cage
settings.

By default nix-cage chooses the launcher from files in the working directory:
`flake.nix` uses `nix develop`, `shell.nix` uses `nix-shell`, and directories
without either run the command directly. Set `launcher` in flake config, or pass
`--launcher`, to force one of `nix-develop`, `nix-shell`, or `direct`.

To make `nix develop` start the sandbox without installing nix-cage globally,
use `mkSandboxedDevShell`:

```nix
{
  inputs.nix-cage.url = "github:corpix/nix-cage";

  outputs = { nix-cage, ... }: {
    devShells.x86_64-linux.default = nix-cage.lib.mkSandboxedDevShell {
      system = "x86_64-linux";
      modules = [
        {
          mounts.rw = [ "~/.emacs.d" ];
          command = "bash";
        }
      ];
    };
  };
}
```

The generated dev shell execs nix-cage from the flake input with
`--launcher direct`, avoiding recursive `nix develop` launches.

Example of legacy `shell.nix`:

```nix
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "nix-shell";
  buildInputs = [
    python3
  ];
}
```

Now start `nix-cage`:

```console
$ nix-cage
bwrap --ro-bind / / --dev-bind /dev /dev ...

[user@localhost:~/projects/src/github.com/corpix/nix-cage]$ cat nix-cage.json
{
    "mounts": {"rw": ["~/.emacs.d"]}
}
```

Each time you start `nix-cage` it will print `bwrap` command which you could use to get the same result while running it manually or for debug. After that the `nix-shell` will be started.

## License

[Unlicense](https://unlicense.org/)
