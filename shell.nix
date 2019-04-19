with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "nix-shell";
  buildInputs = [
    python3
  ];
}
