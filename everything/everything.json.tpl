{
    "rkt": {
        "container": "corpix.github.io/devcage/everything:${version}"
    },
    "mountpoints": {
        "rw": [
            ["~/Projects/cache", "~"],
            ["~/Projects",       "~/Projects"],
            ["~/.emacs.d",       "~/.emacs.d"]
        ],
        "ro": [
            ["~/.bashrc",        "~/.bashrc"],
            ["~/.bash_logout",   "~/.bash_logout"],
            ["~/.bash_profile",  "~/.bash_profile"],
            ["~/.dircolors",     "~/.dircolors"],
            ["~/.gitconfig",     "~/.gitconfig"],
            ["~/.tmux.conf",     "~/.tmux.conf"],
            ["~/.toprc",         "~/.toprc"]
        ]
    },
    "environment": {
        "PATH":   "$HOME/Projects/bin:/usr/bin:/bin:$PATH",
        "GOPATH": "$HOME/Projects"
    }
}
