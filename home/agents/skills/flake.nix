{
  description = "agent skills catalog";

  inputs = {
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
  };

  outputs =
    inputs@{ agent-skills-nix, ... }:
    {
      homeManagerModules.default = {
        imports = [
          agent-skills-nix.homeManagerModules.default
          (import ./home-manager.nix inputs)
        ];
      };
    };
}
