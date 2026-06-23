{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs
    bun
    pnpm
    vtsls
  ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.bun/bin"
  ];
}
