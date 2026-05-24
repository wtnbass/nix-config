{ pkgs, user, ... }:

{
  imports = [
    ../../home/agents
    ../../home/fish.nix
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
    gcc
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
