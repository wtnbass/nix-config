{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit =  ''
      set fish_greeting

      set -g hydro_color_pwd blue
      set -g hydro_color_git green
      set -g hydro_color_error red
      set -g hydro_color_prompt cyan
      set -g hydro_color_duration yellow

      # mise (tools.nix) のシェル統合
      if command -q mise
        mise activate fish | source
      end
    '';
    shellAliases = {
      ls = "eza -h --git --icons";
      ll = "ls -l";
      la = "ls -a";
      lla = "ls -la";
    };
    shellAbbrs = {
      gst = "git status";
      gd = "git diff";
      ga = "git add .";
      gc = "git commit";
      gl = "git log --oneline";
      gp = "git push";
      gpl = "git pull";
      gsw = "git switch";
      lg = "lazygit";

      t = "tmux";
      ta = "tmux attach";

      c = "claude";

      g = "gcd";
      ghw = "cd (ghq root)/github.com/wtnbass";
    };
    plugins = [
      { name = "fzf-fish";    src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "done";        src = pkgs.fishPlugins.done.src; }
      { name = "hydro";       src = pkgs.fishPlugins.hydro.src; }
      { name = "autopair";    src = pkgs.fishPlugins.autopair.src; }
      { name = "sponge";      src = pkgs.fishPlugins.sponge.src; }
    ];
    functions = {
      gcd = ''
        set -l dir (ghq list --full-path | fzf --query "$argv" --select-1 --exit-0)
        if test -n "$dir"
            cd $dir
            commandline -f repaint
        end
      '';
    };
  };
}
