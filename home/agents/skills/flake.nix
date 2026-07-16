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
    ketch = {
      url = "github:1broseidon/ketch";
      flake = false;
    };
    cognitive-rhythm-writing = {
      url = "git+https://gist.github.com/k16shikano/eb2929f13ed19c97188393d297be8432.git";
      flake = false;
    };
    japanese-tech-writing = {
      url = "git+https://gist.github.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d.git";
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
