{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (callPackage ./cmd-eikana.nix { })
    podman
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

  # Ghostty configuration
  xdg.configFile."ghostty/config".source = ./ghostty_config;
}
