{ pkgs, user, ... }:

{
  imports = [
    ../../home/agents
    ../../home/zsh.nix
    ../../home/ghostty.nix
    ../../home/git.nix
    ../../home/helix
    ../../home/karabiner.nix
    ../../home/langs
    ../../home/ssh.nix
    ../../home/tmux.nix
    ../../home/tools.nix
    ../../home/zed-editor.nix
  ];

  home.username = user.username;
  home.homeDirectory = user.home;
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    vscode
    # podman
    # docker-client
    # docker-compose
    udev-gothic-nf
  ];

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

}
