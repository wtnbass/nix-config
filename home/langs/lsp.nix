{ pkgs, ... }:

# 言語をまたいで使う共通 LSP / 最低限欲しい LSP の置き場。
# 特定言語に強く紐づく LSP は ./<lang>.nix 側に置く。
{
  home.packages = with pkgs; [
    vscode-langservers-extracted
    markdown-oxide
    yaml-language-server
    tombi
    dockerfile-language-server
    docker-compose-language-service
    bash-language-server
  ];
}
