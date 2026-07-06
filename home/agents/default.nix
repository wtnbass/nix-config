{ pkgs, ... }:

{
  home.packages = with pkgs; [
    llm-agents.claude-code
    llm-agents.codex
    llm-agents.pi
    llm-agents.herdr
  ];

  # 全プロジェクト共通の Claude Code 向け指示
  home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;

  # statusline は ~/.claude/settings.json の statusLine 設定からこのパスを参照している
  home.file.".claude/statusline-command.sh" = {
    source = ./statusline-command.sh;
    executable = true;
  };

  home.file.".config/herdr/config.toml".source = ./herdr-config.toml;

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
      "grilling"
      "handoff"
      "grill-with-docs"
      "japanese-tech-writing"
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
