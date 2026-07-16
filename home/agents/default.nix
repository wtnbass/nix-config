{ pkgs, lib, ... }:

let
  # pi の拡張パッケージ。~/.pi/agent/settings.json の packages に記録されるが、
  # settings.json は pi 自身も書き換えるため symlink 管理はできない。
  # activation で未導入のものだけ pi install する。
  piPackages = [
    "npm:pi-subagents"
    "npm:pi-agent-browser-native"
  ];

in
{
  home.packages = with pkgs; [
    llm-agents.claude-code
    llm-agents.codex
    llm-agents.pi
    agent-browser # pi-agent-browser-native が PATH に要求する CLI
  ];

  home.activation.piInstallPackages = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    piSettings="''${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}/settings.json"
    for pkg in ${lib.escapeShellArgs piPackages}; do
      if ! grep -q "\"$pkg[\"@]" "$piSettings" 2>/dev/null; then
        run ${pkgs.llm-agents.pi}/bin/pi install "$pkg" \
          || verboseEcho "pi install $pkg failed (offline?): re-run 'pi install $pkg' manually"
      fi
    done
  '';

  # 全プロジェクト共通の Claude Code 向け指示
  home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;

  # statusline は ~/.claude/settings.json の statusLine 設定からこのパスを参照している
  home.file.".claude/statusline-command.sh" = {
    source = ./statusline-command.sh;
    executable = true;
  };
}
