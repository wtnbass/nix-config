{ config, pkgs, ... }:

{
  # rust-bin は flake.nix で追加している rust-overlay 経由
  home.packages = with pkgs; [
    rust-bin.stable.latest.default
    rust-analyzer
  ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
  ];
}
