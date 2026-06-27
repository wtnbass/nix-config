{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    nodejs
    deno
    bun
    pnpm

    python3
    uv

    # php
    # phpPackages.composer

    # lua

    jdk
    maven

    go
    golangci-lint
    delve

    # rust-bin.stable.latest.default

    # ghc
    # cabal-install

    # flutter
  ];

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/go";
    JAVA_HOME = "${pkgs.jdk.home}";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.bun/bin"
    "${config.home.homeDirectory}/.deno/bin"
    "${config.home.homeDirectory}/.cargo/bin"
    "${config.home.homeDirectory}/go/bin"
    "${config.home.homeDirectory}/.cabal/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];
}
