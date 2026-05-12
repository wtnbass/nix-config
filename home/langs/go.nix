{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    go
    gopls
    golangci-lint
    delve
  ];

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/go";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/go/bin"
  ];
}
