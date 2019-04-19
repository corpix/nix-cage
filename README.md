nix-cage
--------------

Sandboxed environments with `bwrap` and `nix` package manager.

## Requirements

- Python
- Bubblewrap
- Nix

## Basics

For basic usage there are 2 steps:

- create `shell.nix` with settings you need
- start `nix-cage`

Example of `shell.nix`:

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
