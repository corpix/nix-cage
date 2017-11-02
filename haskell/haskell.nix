{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    stack
    ghc
    haskellPackages.hlint
    haskellPackages.hindent
    haskellPackages.stylish-haskell
    haskellPackages.cabal-install
    haskellPackages.intero
  ];
}
