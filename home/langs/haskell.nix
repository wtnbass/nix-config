{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ghc
    cabal-install
    haskell-language-server
  ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.cabal/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];
}
