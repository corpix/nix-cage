with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "devcage-javascript-shell";
  buildInputs = [
    nodejs
  ];
}
