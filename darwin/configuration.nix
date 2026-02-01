{ config, pkgs, ... }:

let
  user = import ../user.nix;
in
{
  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  system.primaryUser = user.username;

  users.users.${user.username} = {
    name = user.username;
    home = "/Users/${user.username}";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages (installed system-wide)
  environment.systemPackages = with pkgs; [
    vim
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

    casks = [
      "azookey"
      "ghostty"
      "karabiner-elements"
      "raycast"
      "visual-studio-code"
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
