{
    "rkt": {
        "container": "corpix.github.io/devcage/everything:${version}"
    },
    "mountpoints": {
        "rw": [
            ["/tmp",             "/tmp"],
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
        "PATH":   "$HOME/Projects/bin:$PATH",
        "GOPATH": "$HOME/Projects"
    }
}
