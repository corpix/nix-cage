with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "devcage-clojure-shell";
  buildInputs = [
    clojure
    boot
  ];
}
