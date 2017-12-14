with import <nixpkgs> {};
let
  parts = map (v: (import v).buildInputs) [
    ./clojure.nix
    ./c.nix
    ./go.nix
    ./haskell.nix
    ./java.nix
    ./javascript.nix
    ./rust.nix
    ./database.nix
  ];
in stdenv.mkDerivation {
  name = "devcage-shell";
  buildInputs = [
    aspell
    aspellDicts.en
    curl
    dnsutils
    file
    git
    glibcLocales
    gnumake
    graphviz-nox
    htop
    iotop
    iproute
    iputils
    libarchive
    lzma
    mc
    p7zip
    procps
    sshfs
    sshfs-fuse
    tmux
    tree
    unzip
    wget
    which
  ] ++ parts;
}
