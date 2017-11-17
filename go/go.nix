{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ncurses
    go
    gocode
    go-bindata
    glide
    godef
    bison
  ];
}
