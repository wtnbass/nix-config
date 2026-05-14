{ ... }:

{
  programs.agent-skills = {
    enable = true;
    sources.anthropic = {
      input = "anthropic-skills";
      subdir = "skills";
      idPrefix = "anthropic";
    };
    sources.local = {
      path = ./skills;
      idPrefix = "local";
    };
    skills.enable = [
      "anthropic/frontend-design"
      "anthropic/skill-creator"
    ];
    skills.enableAll = true;
    targets.claude.enable = true;
    targets.codex.enable = true;
  };
}
