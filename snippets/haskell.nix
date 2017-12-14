with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "devcage-haskell-shell";
  buildInputs = [
    stack
  ] ++ (with haskellPackages; [
    hlint
    hindent
    stylish-haskell
    cabal-install
  ]);
}
