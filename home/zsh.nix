{ pkgs, ... }:

{
  programs.fzf.enableZshIntegration = true;
  programs.zoxide.enableZshIntegration = true;
  programs.direnv.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    initContent = ''
      # pure prompt
      autoload -U promptinit; promptinit
      prompt pure

      # mise
      if command -v mise &>/dev/null; then
        eval "$(mise activate zsh)"
      fi

      # git-wt
      if command -v git-wt &>/dev/null; then
        eval "$(git wt --init zsh)"
      fi

      # gcd: ghq + fzf
      gcd() {
        local dir
        dir=$(ghq list --full-path | fzf --query "$*" --select-1 --exit-0)
        if [[ -n "$dir" ]]; then
          cd "$dir"
        fi
      }
    '';
    shellAliases = {
      ls = "eza -h --git --icons";
      ll = "ls -l";
      la = "ls -a";
      lla = "ls -la";
    };
    zsh-abbr = {
      enable = true;
      abbreviations = {
        gst = "git status";
        gd = "git diff";
        ga = "git add .";
        gc = "git commit";
        gl = "git log --oneline";
        gf = "git fetch -ap";
        gp = "git push";
        gpl = "git pull";
        gsw = "git switch";
        lg = "lazygit";
        t = "tmux";
        ta = "tmux attach";
        c = "claude";
        g = "gcd";
        ghw = ''cd "$(ghq root)/github.com/wtnbass"'';
      };
    };
  };

  home.packages = with pkgs; [
    pure-prompt
    zsh-completions
  ];
}
