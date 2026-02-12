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
    zoxide
    jq
    jujutsu
    difftastic
    gh
    gitui
    lazygit
    ghq
    yazi
    python3
    uv
    ruff
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

    envExtra = ''
      export PATH="$PATH:$HOME/.bun/bin"
    '';

    initContent = ''
function ghq-fzf() {
  local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^g' ghq-fzf  
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      format = builtins.concatStringsSep "" [
        "$os "
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$nodejs"
        "$bun"
        "$golang"
        "$python"
        "$rust"
        "$java"
        "$kotlin"
        "$lua"
        "$fill"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      palette = "kanagawa_wave";

      palettes.kanagawa_wave = {
        color_blue = "#7E9CD8"; # crystalBlue
        color_green = "#98BB6C"; # springGreen
        color_spring_blue = "#7FB4CA"; # springBlue
        color_violet = "#957FB8"; # oniViolet
        color_orange = "#FFA066"; # surimiOrange
        color_red = "#FF5D62"; # peachRed
        color_gray = "#727169"; # fujiGray
      };

      os = {
        disabled = false;
        style = "fg:color_violet";
        symbols = {
          NixOS = " ";
          Arch = " ";
          Ubuntu = " ";
          Debian = " ";
          Macos = " ";
          Windows = "󰍲 ";
          Linux = " ";
        };
      };

      directory = {
        style = "bold fg:color_blue";
        read_only = " 󰌾";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = " ";
        style = "fg:color_green";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

      git_status = {
        style = "fg:color_red";
        format = "[$all_status$ahead_behind]($style)";
      };

      nix_shell = {
        symbol = " ";
        style = "fg:color_spring_blue";
        format = "[$symbol$state]($style) ";
      };

      nodejs = {
        symbol = " ";
        style = "fg:color_orange";
        format = "[$symbol$version]($style) ";
      };

      bun = {
        symbol = " ";
        style = "fg:color_orange";
        format = "[$symbol$version]($style) ";
      };

      golang = {
        symbol = " ";
        style = "fg:color_orange";
        format = "[$symbol$version]($style) ";
      };

      python = {
        symbol = " ";
        style = "fg:color_orange";
        format = "[$symbol$version]($style) ";
      };

      rust = {
        symbol = "󱘗 ";
        style = "fg:color_orange";
        format = "[$symbol$version]($style) ";
      };

      java = {
        symbol = " ";
        style = "fg:color_orange";
        format = "[$symbol$version]($style) ";
      };

      kotlin = {
        symbol = " ";
        style = "fg:color_orange";
        format = "[$symbol$version]($style) ";
      };

      lua = {
        symbol = " ";
        style = "fg:color_orange";
        format = "[$symbol$version]($style) ";
      };

      fill.symbol = " ";

      cmd_duration = {
        style = "fg:color_gray";
        format = " $duration";
        min_time = 3000;
      };

      character = {
        success_symbol = "[❯](bold fg:color_green)";
        error_symbol = "[❯](bold fg:color_red)";
        vimcmd_symbol = "[❮](bold fg:color_green)";
        vimcmd_replace_one_symbol = "[❮](bold fg:color_violet)";
        vimcmd_replace_symbol = "[❮](bold fg:color_violet)";
        vimcmd_visual_symbol = "[❮](bold fg:color_blue)";
      };
    };
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
      ghq.root = "~/code";

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
      core.excludesfile = "~/.gitignore";
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

    prefix = "C-q";
    mouse = true;
    escapeTime = 0;
    historyLimit = 5000;

    extraConfig = ''
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"

      bind x kill-pane
      bind X kill-window

      bind + split-window -h
      bind = split-window -h
      bind - split-window -v

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -n S-Left resize-pane -L 2
      bind -n S-Down resize-pane -D 2
      bind -n S-Up resize-pane -U 2
      bind -n S-Right resize-pane -R 2
    '';
  };
}
