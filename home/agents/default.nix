{ pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
    pi-coding-agent
  ];

  # statusline は ~/.claude/settings.json の statusLine 設定からこのパスを参照している
  home.file.".claude/statusline-command.sh" = {
    source = ./statusline-command.sh;
    executable = true;
  };

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
      "git-commit"
    ];
    targets.claude.enable = true;
    targets.codex.enable = true;
  };
}
