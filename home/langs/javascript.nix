{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs
    bun
    pnpm
    typescript-language-server
  ];
}
