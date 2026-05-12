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
    mise # 言語ランタイムのバージョン管理。fish 側で activate
  ];

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = ["--cmd cd"];
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };
}
