with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "devcage-javascript-shell";
  buildInputs = [
    nodejs-8_x
  ] ++ (with nodePackages; [
    node2nix
  ]);
}
