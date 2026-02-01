{ config, pkgs, ... }:

{
  # Ghostty configuration
  xdg.configFile."ghostty/config".source = ./ghostty_config;

  # Karabiner-Elements configuration
  xdg.configFile."karabiner/karabiner.json".source = ./karabiner.json;
}
