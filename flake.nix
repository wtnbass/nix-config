{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/nixos-wsl/main";
    nix-ld.url = "github:Mic92/nix-ld";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-wsl,
      nix-ld,
      home-manager,
      nix-darwin,
      llm-agents,
      ...
    }:
    let
      user = import ./user.nix;
    in
    {
      # NixOS-WSL configuration
      nixosConfigurations = {
        ${user.hostname} = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit user; };
          modules = [
            ./configuration.nix
            nixos-wsl.nixosModules.default
            {
              system.stateVersion = "25.05";
              wsl.enable = true;
            }

            nix-ld.nixosModules.nix-ld
            { programs.nix-ld.dev.enable = true; }

            {
              nixpkgs.overlays = [
                llm-agents.overlays.default
              ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit user; };
              home-manager.users.${user.username} = import ./home.nix;
            }
          ];
        };
      };

      # macOS (nix-darwin) configuration
      darwinConfigurations = {
        ${user.hostname} = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit user; };
          modules = [
            ./darwin/configuration.nix
            {
              nixpkgs.overlays = [
                llm-agents.overlays.default
              ];
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit user; };
              home-manager.users.${user.username} = {
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
