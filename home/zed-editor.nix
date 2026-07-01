{ ... }:

# Zed 本体は Homebrew cask からインストールし、
# home-manager では設定ファイルのみ管理する。
{
  programs.zed-editor = {
    enable = true;
    package = null;

    mutableUserSettings = false;

    extensions = [
      "nix"
      "toml"
      "make"
      "dockerfile"
      "yaml"
      "markdown"
    ];

    userSettings = {
      theme = "Kanagawa Wave";

      ui_font_family = "UDEV Gothic NF";
      buffer_font_family = "UDEV Gothic NF";
      terminal = {
        font_family = "UDEV Gothic NF";
      };

      helix_mode = false;
      vim_mode = false;

      soft_wrap = "editor_width";
      show_wrap_guides = false;

      file_scan_exclusions = [
        "**/.git"
        "**/.direnv"
        "**/node_modules"
        "**/result"
      ];
    };
  };
}
