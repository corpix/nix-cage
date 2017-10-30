{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ncurses
    go
    gocode
    glide
    bison
  ];
}
