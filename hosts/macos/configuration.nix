{ pkgs, user, ... }:

{
  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  system.primaryUser = user.username;

  users.knownUsers = [ user.username ];
  users.users.${user.username} = {
    uid = 501;
    name = user.username;
    home = user.home;
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # マニュアル生成 (darwin-manual/options.json) を無効化。
  # Determinate Nix の lazy-trees と相性が悪く store path 警告が出るため。
  documentation.enable = false;

  # darwin-uninstaller は内部でデフォルト設定 (documentation 有効) の
  # システムを評価するため、nixpkgs-unstable の nixos-render-docs との
  # 非互換 (--toc-depth 削除) でビルドが失敗する。必要なら
  # `nix run nix-darwin#darwin-uninstaller` で都度実行できる。
  system.tools.darwin-uninstaller.enable = false;

  # System packages (installed system-wide)
  environment.systemPackages = with pkgs; [
    vim
  ];
  environment.shells = [
    pkgs.fish
    pkgs.zsh
  ];

  # Homebrew management via nix-darwin
  homebrew = {
    enable = true;

    # Uninstall packages not listed here
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    brews = [
      "mise"
      "container"
    ];

    casks = [
      "azookey"
      "karabiner-elements"
      "raycast"
      "ghostty"
      "codex-app"
      "zed"
    ];

  };

  # Enable Touch ID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # macOS system settings
  system.defaults = {
    NSGlobalDomain = {
      # Keyboard settings
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false;

      # Expand save panel by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };

    dock = {
      # Auto-hide the Dock
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;

      # Don't show recent apps
      show-recents = false;
    };

    finder = {
      # Show file extensions
      AppleShowAllExtensions = true;

      # Show path bar
      ShowPathbar = true;

      # Default to list view
      FXPreferredViewStyle = "Nlsv";
    };

    trackpad = {
      # Tap to click
      Clicking = true;
    };
  };

  # Used for backwards compatibility
  system.stateVersion = 6;
}
