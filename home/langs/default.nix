{ system, ... }:

# imports は config / pkgs より先に解決されるため、pkgs.stdenv で分岐すると
# 無限再帰になる。代わりに specialArgs で渡す system 文字列で判定する。
let
  isDarwin = builtins.match ".*-darwin" system != null;

  # macOS / WSL どちらでも入れる言語。
  common = [
    ./javascript.nix
    ./lsp.nix
    ./lua.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./go.nix
    ./haskell.nix
    # ./zig.nix
    # ./java.nix
    # ./php.nix
  ];

  # macOS (darwin) 専用の言語。必要になったらここに追加する。
  darwin = [
    ./flutter.nix
    # ./swift.nix
  ];

  # WSL (Linux) 専用の言語。必要になったらここに追加する。
  linux = [
  ];
in
{
  imports = common ++ (if isDarwin then darwin else linux);
}
