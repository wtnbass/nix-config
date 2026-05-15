{ ... }:

{
  programs.agent-skills = {
    enable = true;
    sources.anthropic = {
      input = "anthropic-skills";
      subdir = "skills";
    };
    sources.local = {
      path = ./skills;
    };
    skills.enable = [
      "frontend-design"
      "skill-creator"
      "nix-config"
    ];
    targets.claude.enable = true;
    targets.codex.enable = true;
  };
}
