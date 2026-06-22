{
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" 
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

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
    llm-agents.url = "github:numtide/llm-agents.nix";
    agent-skills-nix.url = "github:Kyure-A/agent-skills-nix";
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    google-modern-web-guidance = {
      url = "github:GoogleChrome/modern-web-guidance";
      flake = false;
    };
    lazyvim = {
      url = "github:LazyVim/starter";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixos-wsl,
      home-manager,
      nix-darwin,
      rust-overlay,
      llm-agents,
      agent-skills-nix,
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
        llm-agents.overlays.default
        # カスタムパッケージ (pkgs/ 配下) を pkgs.<name> として公開する
        (final: _prev: {
          cmd-eikana = final.callPackage ./pkgs/cmd-eikana.nix { };
        })
      ];
      mkExtraSpecialArgs = system: user: {
        inherit user inputs system;
      };
    in
    {
      # NixOS-WSL configuration
      nixosConfigurations = {
        ${nixosUser.hostname} = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { user = nixosUser; };
          modules = [
            ./hosts/wsl/configuration.nix
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
              home-manager.sharedModules = [ agent-skills-nix.homeManagerModules.default ];
              home-manager.users.${nixosUser.username} = {
                imports = [ ./hosts/wsl/home.nix ];
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
            ./hosts/macos/configuration.nix
            { nixpkgs.overlays = overlays; }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = mkExtraSpecialArgs "aarch64-darwin" darwinUser;
              home-manager.sharedModules = [ agent-skills-nix.homeManagerModules.default ];
              home-manager.users.${darwinUser.username} = {
                imports = [ ./hosts/macos/home.nix ];
              };
            }
          ];
        };
      };
    };
}
