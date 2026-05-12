{ pkgs, user, ... }:

{
  imports = [
    ../../home/claude
    ../../home/fish.nix
    ../../home/ghostty
    ../../home/git.nix
    ../../home/helix.nix
    ../../home/langs
    ../../home/ssh.nix
    ../../home/tmux.nix
    ../../home/tools.nix
  ];

  home.username = user.username;
  home.homeDirectory = user.home;
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    cmd-eikana
    vscode
    zed-editor
    podman
    docker-client
    docker-compose
    udev-gothic-nf
  ];

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  programs.fish.interactiveShellInit = ''
    if command -q podman
        set socket (podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}' 2>/dev/null)

        if test -n "$socket"
            set -gx DOCKER_HOST "unix://$socket"
        end
    end
  '';
}
