{ pkgs, ... }:

{
  home.packages = with pkgs; [
    php
    phpPackages.composer
    nodePackages.intelephense
  ];
}
