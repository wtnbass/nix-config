{ pkgs, ... }:

{
  home.packages = [
    (pkgs.callPackage ./cmd-eikana.nix { })
  ];

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  # Ghostty configuration
  xdg.configFile."ghostty/config".source = ./ghostty_config;
}
