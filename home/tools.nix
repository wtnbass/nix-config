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
  ];

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };
}
