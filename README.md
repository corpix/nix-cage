nix-cage
--------------

Sandboxed environments with `bwrap`, `nix-shell` and `emacs`.

## Requirements

- Linux(NixOS is better)
- Python
- Bubblewrap
- Nix
- Nix-shell

## Basics

We want to run a sandbox to develop some project what we should do?

First of all we need to create a `nix-cage` configuration in the root of the
project repository in `nix-cage.json`. This configuration will be read when you
start `nix-cage` in this repository:

``` json
{
    "mounts": {
        "rw": [
            ["~/.emacs.d", "~/.emacs.d"],
            [".",          "."]
        ],
        "ro": [
            ["~/.bashrc",        "~/.bashrc"],
            ["~/.profile",       "~/.profile"],
            ["~/.config/fish",   "~/.config/fish"],
            ["~/.config/xonsh",  "~/.config/xonsh"],
            ["~/.xonshrc",       "~/.xonshrc"],
            ["~/.gitconfig",     "~/.gitconfig"]
        ],
        "tmpfs": [
            "~"
        ]
    },
    "environment": {
        "TERM": "screen-256color"
    }
}
```

Here we mounting `~/.emacs.d`, `.`(which is current working directory) available to read and write
and some other configuration files available read-only
into the cage. Also we masking a user home directory with a `tmpfs`.

- `mounts` is a hashmap of the mountpoints from your system into a cage
- `environment` is a hashmap of environment variables set into a cage

Mounts could be:
  - `rw` (list of pairs) you could read && write from the cage
  - `ro` (list of pairs) you could read, but not write from the cage
  - `tmpfs` (list of strings) this directories in the cage will be a [tmpfs](https://en.wikipedia.org/wiki/Tmpfs)
  - `dev` (list of pairs) bindmount directories to the cage allowing devices access

You could see that not all types of mounts are present in example `nix-cage.json`, but we will
talk about that in next section.

String values of each mount point support a variable substitution from the host-system environment,
for example this is correct:

> You don't need to write all mounts like this, shell expansion is also works,
> so paths like `~/.emacs.d` could be used instead.

``` json
{
    "mounts": {
        "rw": [
            ["$HOME/.emacs.d", "/home/$USER/.emacs.d"]
        ]
    }
}
```

Environment variables in the cage are same as in your host system, but you could change the
values of variables that will be available in the cage(or mask them with empty value).
In the example `nix-cage.json` I have changed `TERM` variable to have value `screen-256color`.

Environment variables values also support substitution:

> This example adds `~/bin` directory inside cage to the `PATH`

``` json
{
    "environment": {
        "PATH": "~/bin:$PATH"
    }
}
```

Ok, now we have a `nix-cage.json` file and basic understanding of the contents. Whats next?

We have described a sandboxing, now we need to describe our environment inside the sandbox,
here we will need a `shell.nix` file for a `nix-shell` that will be started for us inside the cage.

To make things simple I'll show you an environment with `python36` available:

``` nix
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "nix-cage-shell";
  buildInputs = [
    python36
  ];
}
```

Now you should have two files:
    - `nix-cage.json`
    - `shell.nix`

We are ready to enter the cage:

``` console
$ ./nix-cage
```

Your default shell should start.

## Going deeper

In the previous section we have learned:
    - how to create mounts
    - how to pass environment variables

Now we will learn:
    - how to pass different `nix` file to `nix-shell`
    - how to tell `nix-cage` what command should be executed inside a cage
    - how to pass arbitrary arguments to `bwrap` and `nix-shell`
    - what config parts are default and how they merged with user-providen config

I am begging you to read the `nix-cage -h` output carefully:

``` console
$ ./nix-cage --help
usage: nix-cage [-h] [--config CONFIG] [--exec EXEC] [--entrypoint ENTRYPOINT]
                [-v]
                [path [path ...]]
Nix-cage, sandboxed environments with nix-shell
positional arguments:
  path                  One or more directories or files which will be mounted
                        into the sandbox. Paths inside sandbox are same as in
                        host system. Mounts are read/write by default, but you
                        could change this by appending one of
                        :ro|:rw|:dev|:tmpfs suffixes to the path.
optional arguments:
  -h, --help            show this help message and exit
  --config CONFIG       Config file path, by default it will read JSON config
                        from current directory.
  --exec EXEC           Application to execute inside the sandbox, by default
                        it is you $SHELL env variable.
  --entrypoint ENTRYPOINT
                        Path to shell.nix file which will be passed to nix-
                        shell, by default it is shell.nix from current
                        directory.
  --show-default-config
                        Dumps a default config in JSON.
  -v, --verbose         Verbose mode.
```

Now it should be obvious:
    - to pass different `nix` file to `nix-shell` you should `./nix-cage --entrypoint ...`
    - to tell `nix-cage` what command should be executed inside a cage you should `./nix-cage --exec ...`

Now we are ready to get back to config for more advanced configuration.
In addition to `mounts` and `environment` sections of config file there is a section called `arguments`:

``` json
{
    "mounts":      {},
    "environment": {},
    "arguments":   {
        "entrypoint": "",
        "exec":       [],
        "bwrap":      [],
        "nix-shell":  []
    }
}
```

- `entrypoint` is same as `--entrypoint` argument
- `exec` is same as `--exec` argument, it could take a list(`["emacs", "-nw"]`) or string(`"emacs -nw"`)
- `bwrap` is a list of `bwrap` arguments
- `nix-shell` is a list of `nix-shell` arguments

Now we know how to pass arbitrary arguments to `bwrap` and `nix-shell`.

Next two parts are:
    - default config
    - how default config merged with user config/arguments

To see the default config just add `--show-default-config` to the list of arguments:

``` console
$ ./nix-cage --show-default-config
{
    "mounts": {
        "rw": [],
        "ro": [
            [
                "/",
                "/"
            ]
        ],
        "dev": [
            [
                "/dev",
                "/dev"
            ]
        ],
        "tmpfs": [
            "/tmp",
            "/run/user/1001",
            "/run/media/user"
        ]
    },
    "environment": {
        "HOME": "/home/user",
        "TERM": "screen-256color",
        "SHELL": "/nix/store/wgj9s4v93swcfpm1pwylc16jwrrililg-bash-4.4-p12/bin/bash",
        "NIX_REMOTE": "daemon"
    },
    "arguments": {
        "entrypoint": "",
        "exec": [],
        "bwrap": [
            "--hostname",
            "localhost"
        ],
        "nix-shell": []
    }
}
```

We could see that some variables was populated from current environment.

How default config merged with user providen config/arguments?

1. Arguments always take precedence on config
2. Mounts section providen by user always appended to the end(mount order could be changed, for example `/home` should mounted before `/home/foo`)
3. Environment section merges with user providen as a hashmap where user providen environment take precedence
4. Arguments section merges with user providen as a hashmap where user providen arguments take precedence


You could see the merged configuration(and other things) if you run `nix-cage` with `-v` or `--verbose` flag.

That's all, folks :) I hope working with this tool will be easy for you, if not - create an issue or send me a PR!
