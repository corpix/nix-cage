with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "devcage-go-shell";
  buildInputs = [
    ncurses
    go
    gocode
    go-bindata
    glide
    godef
    bison
  ];
}
