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
    hunk
    ghui
    backlog-md
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
