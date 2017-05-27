{
    "container": "./build/rust-${version}-linux-amd64.aci",
    "mountpoints": {
        "~/Projects": "/home/user/Projects",
        "~/.emacs.d": "/home/user/.emacs.d",
        "~/dotfiles/shell/.zlogin": "/home/user/.zlogin",
        "~/dotfiles/shell/.zlogout": "/home/user/.zlogout",
        "~/dotfiles/shell/.zprezto": "/home/user/.zprezto",
        "~/dotfiles/shell/.zpreztorc": "/home/user/.zpreztorc",
        "~/dotfiles/shell/.zprofile": "/home/user/.zprofile",
        "~/dotfiles/shell/.zshenv": "/home/user/.zshenv",
        "~/dotfiles/shell/.zshrc": "/home/user/.zshrc",
        "~/dotfiles/shell/.dircolors": "/home/user/.dircolors",
        "~/Projects/cache/.rustup": "/home/user/.rustup",
        "~/Projects/cache/.cargo": "/home/user/.cargo"
    },
    "rktArguments": ["--insecure-options=all"]
}
