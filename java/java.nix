{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (lowPrio jre)
    jdk
    ant
    gradle
    groovy
  ];
}
