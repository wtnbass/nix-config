# flake.nix から inputs をまるごと受け取る。source の追加は
# flake.nix の inputs とここの sources に 1 エントリずつ足すだけでよい。
inputs: {
  programs.agent-skills = {
    enable = true;
    sources.anthropic = {
      path = inputs.anthropic-skills;
      subdir = "skills";
    };
    sources.mattpocock-skills-engineering = {
      path = inputs.mattpocock-skills;
      subdir = "skills/engineering";
    };
    sources.mattpocock-skills-productivity = {
      path = inputs.mattpocock-skills;
      subdir = "skills/productivity";
    };
    sources.google-modern-web-guidance = {
      path = inputs.google-modern-web-guidance;
      subdir = "skills";
    };
    sources.ketch = {
      path = inputs.ketch;
      subdir = "skills";
    };
    sources.cognitive-rhythm-writing = {
      path = inputs.cognitive-rhythm-writing;
    };
    sources.japanese-tech-writing = {
      path = inputs.japanese-tech-writing;
    };
    # この flake 直下の SKILL.md を持つディレクトリ群 (git-commit など)
    sources.local = {
      path = ./.;
    };
    skills.enable = [
      "frontend-design"
      "skill-creator"
      "git-commit"
      "nix-run"
      "modern-web-guidance"
      "japanese-tech-writing"
      "cognitive-rhythm-writing"
      "handoff"
      "grill-me"
      "grill-with-docs"
      "grilling"
      "wayfinder"
      "ketch"
    ];
    targets.claude.enable = true;
    targets.codex.enable = true;
    targets.pi.enable = true;
  };
}
