{ ... }:

{
  # 普段使う言語のみここに列挙する。
  # go / rust / zig / haskell は使うときに各 host 側で import する。
  imports = [
    ./javascript.nix
    ./lsp.nix
    ./nix.nix
    ./python.nix
  ];
}
