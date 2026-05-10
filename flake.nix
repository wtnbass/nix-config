{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/nixos-wsl/main";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      nixpkgs,
      nixos-wsl,
      home-manager,
      nix-darwin,
      rust-overlay,
      ...
    }:
    let
      darwinUser = {
        username = "watanabekeisuke";
        hostname = "k-watanabe";
        home = "/Users/watanabekeisuke";
      };
      nixosUser = {
        username = "nixos";
        hostname = "nixos";
        home = "/home/nixos";
      };
      overlays = [
        rust-overlay.overlays.default
      ];
      mkExtraSpecialArgs = system: user: {
        inherit user;
      };
    in
    {
      # NixOS-WSL configuration
      nixosConfigurations = {
        ${nixosUser.hostname} = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { user = nixosUser; };
          modules = [
            ./wsl/configuration.nix
            nixos-wsl.nixosModules.default
            {
              system.stateVersion = "25.05";
              wsl.enable = true;
            }

            { nixpkgs.overlays = overlays; }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = mkExtraSpecialArgs "x86_64-linux" nixosUser;
              home-manager.users.${nixosUser.username} = {
                imports = [
                  ./home.nix
                  ./wsl/home.nix
                ];
              };
            }
          ];
        };
      };

      # macOS (nix-darwin) configuration
      darwinConfigurations = {
        ${darwinUser.hostname} = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { user = darwinUser; };
          modules = [
            ./darwin/configuration.nix
            { nixpkgs.overlays = overlays; }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = mkExtraSpecialArgs "aarch64-darwin" darwinUser;
              home-manager.users.${darwinUser.username} = {
                imports = [
                  ./home.nix
                  ./darwin/home.nix
                ];
              };
            }
          ];
        };
      };
    };
}
