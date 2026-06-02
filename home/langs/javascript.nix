{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs
    bun
    pnpm
    typescript-language-server
  ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.bun/bin"
  ];
}
