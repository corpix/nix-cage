with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "devcage-rust-shell";
  buildInputs = [
    rustup
  ];
}
