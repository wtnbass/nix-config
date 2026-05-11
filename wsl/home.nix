{ pkgs, ... }:

{
  home.sessionVariables = {
    DOCKER_HOST = "unix:///mnt/wsl/shared-docker/docker.sock";
  };

  home.packages = with pkgs; [
    codex
  ];

  programs.fish.interactiveShellInit = ''
    # Ref: https://learn.microsoft.com/ja-jp/windows/terminal/tutorials/new-tab-same-directory#fish
    function storePathForWindowsTerminal --on-variable PWD
        if test -n "$WT_SESSION"
          printf "\e]9;9;%s\e\\" (wslpath -w "$PWD")
        end
    end
  '';
}
