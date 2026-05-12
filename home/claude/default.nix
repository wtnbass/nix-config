{ pkgs, ... }:

{
  home.packages = [ pkgs.claude-code ];

  # statusline は ~/.claude/settings.json の statusLine 設定からこのパスを参照している
  home.file.".claude/statusline-command.sh" = {
    source = ./statusline-command.sh;
    executable = true;
  };
}
