{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, fenix, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems =
        f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system} system);
    in
    {
      devShells = forAllSystems (pkgs: system: {
        default = pkgs.mkShell {
          packages = [
            # stable / beta / complete から選択可能
            fenix.packages.${system}.stable.toolchain
            fenix.packages.${system}.stable.rust-analyzer
          ];
        };
      });
    };
}
