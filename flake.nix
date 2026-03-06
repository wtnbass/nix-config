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
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code-nix.url = "github:sadjow/claude-code-nix";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    gws.url = "github:googleworkspace/cli";
  };

  outputs =
    {
      nixpkgs,
      nixos-wsl,
      home-manager,
      nix-darwin,
      fenix,
      claude-code-nix,
      codex-cli-nix,
      gws,
      ...
    }:
    let
      user = import ./user.nix;
      customOverlay = final: prev: {
        gogcli = final.callPackage ./pkgs/gogcli.nix { };
      };
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

            {
              nixpkgs.overlays = [
                fenix.overlays.default
                customOverlay
              ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit user;
                claude-code = claude-code-nix.packages.x86_64-linux.default;
                codex = codex-cli-nix.packages.x86_64-linux.default;
                gws = gws.packages.x86_64-linux.default;
              };
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
                fenix.overlays.default
                customOverlay
              ];
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                inherit user;
                claude-code = claude-code-nix.packages.aarch64-darwin.default;
                codex = codex-cli-nix.packages.aarch64-darwin.default;
                gws = gws.packages.aarch64-darwin.default;
              };
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
