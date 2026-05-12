{ ... }:

{
  # 普段使う言語のみここに列挙する。
  # go / rust / zig / haskell / java / php は使うときに各 host 側で import する。
  imports = [
    ./javascript.nix
    ./lsp.nix
    ./lua.nix
    ./nix.nix
    ./python.nix
    # ./go.nix
    # ./haskell.nix
    # ./java.nix
    # ./php.nix
    ./rust.nix
    ./zig.nix
  ];
}
