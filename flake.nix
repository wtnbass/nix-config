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
      overlays = [
        fenix.overlays.default
        (final: prev: { })
      ];
      mkExtraSpecialArgs = system: {
        inherit user;
        claude-code = claude-code-nix.packages.${system}.default;
        codex = codex-cli-nix.packages.${system}.default;
        gws = gws.packages.${system}.default;
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

            { nixpkgs.overlays = overlays; }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = mkExtraSpecialArgs "x86_64-linux";
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
            { nixpkgs.overlays = overlays; }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = mkExtraSpecialArgs "aarch64-darwin";
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
