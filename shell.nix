let nixpkgs = <nixpkgs>; in
with import nixpkgs {};
stdenv.mkDerivation {
  name = "nix-shell";
  buildInputs = [
    gnumake
    bashInteractive
    python3
    jq
  ];
  shellHook = ''
    export NIX_PATH=nixpkgs=${nixpkgs}
  '';
}
