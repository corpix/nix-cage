with import <nixpkgs> {}; stdenv.mkDerivation {
  name = "nix-shell";
  buildInputs = [
    gnumake
    bashInteractive
    python3
    jq
  ];
}
