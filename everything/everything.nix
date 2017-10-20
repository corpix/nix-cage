{ config, pkgs, ... }:

{
  imports = [
    ./../go/go.nix
    ./../javascript/javascript.nix
    ./../clojure/clojure.nix
    ./../haskell/haskell.nix
    ./../rust/rust.nix
    ./../java/java.nix
  ];

}
