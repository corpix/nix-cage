{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    clojure
    boot
  ];
}
