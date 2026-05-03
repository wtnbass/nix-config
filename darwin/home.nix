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
      set -gx DOCKER_HOST "unix://"(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}' ^/dev/null)
    end
  '';

  # Ghostty configuration
  xdg.configFile."ghostty/config".source = ./ghostty_config;
}
