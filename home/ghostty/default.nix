{ ... }:

# 現状は macOS の hosts/macos/home.nix からのみ import している
{
  xdg.configFile."ghostty/config".source = ./ghostty_config;
}
