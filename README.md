devcage
--------------

Sandboxed development environments with `bwrap`, `nix-shell` and `emacs`.

## Requirements

- Linux(NixOS is better)
- Python
- Bubblewrap
- Nix
- Nix-shell
- Emacs(optional, you could use vim or any other editor, you could either use IDE which requires X11)

## Example

This is a configuration I use. It requires that you create a `~/projects` directory:

``` console
$ mkdir -p ~/projects/{src,bin,cache}
```

``` console
$ ./devcage --verbose --entrypoint ./shell.nix  \
            --config ~/devcage.json             \
            ~/projects/src/github.com/corpix    \
            ~/projects/src/github.com/cryptounicorns
```

Where `~/devcage.json` content is:

``` json
{
    "mounts": {
        "rw": [
            ["~/projects/cache", "~"],
            ["~/.emacs.d",       "~/.emacs.d"]
        ],
        "ro": [
            ["~/.bashrc",        "~/.bashrc"],
            ["~/.bash_logout",   "~/.bash_logout"],
            ["~/.bash_profile",  "~/.bash_profile"],
            ["~/.gitconfig",     "~/.gitconfig"]
        ]
    },
    "environment": {
        "PATH":   "$HOME/.local/bin:$HOME/projects/bin:$PATH",
        "GOPATH": "$HOME/projects"
    },
    "arguments": {
        "exec": ["emacs", "-nw"]
    }
}
```
