{
  config,
  pkgs,
  system,
  ...
}:

# imports は config / pkgs より先に解決されるため、pkgs.stdenv で分岐すると
# 無限再帰になる。代わりに specialArgs で渡す system 文字列で判定する。
let
  isDarwin = builtins.match ".*-darwin" system != null;
in
{
  # LSP / formatter は Helix 側で管理し、ここは runtime / build tool に寄せる。
  home.packages =
    with pkgs;
    [
      nodejs
      deno
      bun
      pnpm

      lua

      python3
      uv

      rust-bin.stable.latest.default

      go
      golangci-lint
      delve

      ghc
      cabal-install

      zig

      jdk
      maven
      gradle
      kotlin

      php
      phpPackages.composer
    ]
    ++ (if isDarwin then [ pkgs.flutter ] else [ ]);

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
