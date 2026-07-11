{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ffmpeg
    ripgrep
    bat
    fd
    eza
    ghq
    jq
    gh
    lazygit
    yazi
    ghui
    backlog-md
    lumen
    mdcat
    glow
  ];

  programs.fzf.enable = true;

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
