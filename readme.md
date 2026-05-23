nix-cage
--------------

[![Build Status](https://travis-ci.org/corpix/nix-cage.svg?branch=master)](https://travis-ci.org/corpix/nix-cage)

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
