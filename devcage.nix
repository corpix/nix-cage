{ config, pkgs, ... }:

{
  imports = [
    ./base/base.nix
    ./everything/everything.nix
  ];

  environment.systemPackages = with pkgs; [
    rkt
    acbuild
  ];
}
