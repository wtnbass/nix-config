{
  pkgs,
  user,
  claude-code,
  codex,
  gws,
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
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly
    claude-code
    codex
    gws
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.sessionVariables = {
      EDITOR = "hx";
  };

  programs.fish = {
    enable = true;
    interactiveShellInit =  ''
      set fish_greeting

      set -g hydro_color_pwd blue
      set -g hydro_color_git green
      set -g hydro_color_error red
      set -g hydro_color_prompt cyan
      set -g hydro_color_duration yellow
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
      gc = "git commit";
      gl = "git log --oneline";
      gp = "git push";
      gpl = "git pull";
      gsw = "git switch";

      t = "tmux";
      ta = "tmux attach";

      c = "claude";
    };
    plugins = [
      { name = "fzf-fish";    src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "done";        src = pkgs.fishPlugins.done.src; }
      { name = "hydro";       src = pkgs.fishPlugins.hydro.src; }
      { name = "autopair";    src = pkgs.fishPlugins.autopair.src; }
      { name = "sponge";      src = pkgs.fishPlugins.sponge.src; }
    ];
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = ["--cmd cd"];
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
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
        soft-wrap = {
          enable = true;
          max-wrap = 25;
          max-indent-retain = 0;
          wrap-indicator = "";
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
