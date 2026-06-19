{ pkgs, ... }:

{
  home.packages = with pkgs; [
    llm-agents.claude-code
    llm-agents.codex
    llm-agents.pi
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
    sources.mattpocock-skills-engineering = {
      input = "mattpocock-skills";
      subdir = "skills/engineering";
    };
    sources.mattpocock-skills-productivity = {
      input = "mattpocock-skills";
      subdir = "skills/productivity";
    };
    sources.google-modern-web-guidance = {
      input = "google-modern-web-guidance";
      subdir = "skills";
    };
    sources.local = {
      path = ./skills;
    };
    skills.enable = [
      "frontend-design"
      "skill-creator"
      "git-commit"
      "nix-run"
      "modern-web-guidance"
      "grill-me"
      "handoff"
      "grill-with-docs"
      "tdd"
    ];
    targets.claude.enable = true;
    targets.codex.enable = true;
    targets.pi = {
      enable = true;
      dest = "\${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}/skills";
    };
  };
}
