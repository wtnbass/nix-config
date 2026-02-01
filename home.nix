{
  pkgs,
  user,
  ...
}:

{
  home.username = user.username;
  home.homeDirectory = user.home;

  home.packages = with pkgs; [
    nixd
    nixfmt
    helix
    neovim
    emacs
    tmux
    ffmpeg
    yt-dlp
    carapace
    ripgrep
    bat
    fd
    eza
    fzf
    jq
    jujutsu
    difftastic
    gh
    gitui
    lazygit
    yazi
    nodejs
    bun
    pnpm
    nodePackages.vscode-langservers-extracted
    nodePackages.typescript-language-server
    markdown-oxide
    nodePackages.yaml-language-server
    tombi
    go
    gopls
    llm-agents.claude-code
    llm-agents.codex
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza -h --git --icons";
      ll = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      t = "tmux";
    };

    sessionVariables = {
      EDITOR = "hx";
    };
  };

  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
  };

  programs.git = {
    enable = true;

    settings = {
      user.name = "wtnbass";
      user.email = "wtnbass@icloud.com";
      "credential \"https://github.com\"".helper = "!gh auth git-credential";
      core.editor = "hx";
      diff.external = "difft";
      merge.ff = "false";
      pull.ff = "only";

      # Ref: https://blog.gitbutler.com/how-git-core-devs-configure-git
      # clearly makes git better
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      init.defaultBranch = "main";
      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = "true";
      diff.renames = "true";
      push.default = "simple";
      push.autoSetupRemote = "true";
      push.followTags = "true";
      fetch.prune = "true";
      fetch.pruneTags = "true";
      fetch.all = "true";

      # why the hell not?
      help.autocorrect = "prompt";
      commit.verbose = "true";
      rerere.enabled = "true";
      rerere.autoupdate = "true";
      # core.excludesfile = ""~/.gitignore"";
      rebase.autoSquash = "true";
      rebase.autoStash = "true";
      rebase.updateRefs = "true";
    };
  };

  xdg.configFile."helix/themes/kanagawa_transparent.toml".text = ''
    inherits = "kanagawa"
    "ui.background" = {}
  '';

  programs.helix = {
    enable = true;
    settings = {
      theme = "kanagawa_transparent";
      editor = {
        line-number = "relative";
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
          git-ignore = true;
        };
      };
      keys.normal = {
        space = {
          space = ":reload-all";
        };
      };
      keys.insert = {
        "C-f" = "move_char_right";
        "C-b" = "move_char_left";
        "C-p" = "move_line_up";
        "C-n" = "move_line_down";
        "C-a" = "goto_line_start";
        "C-e" = "goto_line_end";
      };
    };
  };

  programs.tmux = {
    enable = true;

    prefix = "F1";
    mouse = true;
    escapeTime = 0;
    historyLimit = 5000;

    extraConfig = ''
      bind r source-file ~/.tmux.conf \; display "Reloaded!"
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"

      bind x kill-pane
      bind X kill-window

      bind + split-window -h
      bind = split-window -h
      bind - split-window -v

      bind -n M-Left select-pane -L
      bind -n M-Down select-pane -D
      bind -n M-Up select-pane -U
      bind -n M-Right select-pane -R

      bind -n S-Left resize-pane -L 2
      bind -n S-Down resize-pane -D 2
      bind -n S-Up resize-pane -U 2
      bind -n S-Right resize-pane -R 2
    '';
  };
}
