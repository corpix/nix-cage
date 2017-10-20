{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ncurses
    go
    bison
  ];
}
