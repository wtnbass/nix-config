{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    nixd
    nixfmt
    nodejs
    deno
    bun
    pnpm
    vtsls
    vscode-langservers-extracted
    tailwindcss-language-server
    markdown-oxide
    iwe
    yaml-language-server
    yamlfmt
    tombi
    bash-language-server
    docker-compose-language-service
    dockerfile-language-server
    python3
    uv
    ruff
    php
    phpPackages.composer
    intelephense
    lua
    lua-language-server
    stylua
    jdk
    jdt-language-server
    lombok
    go
    golangci-lint
    delve
    gopls
    rust-bin.stable.latest.default
    rust-analyzer
    ghc
    cabal-install
    haskell-language-server
    flutter
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
