{
  imports = [
    ./languages.nix
  ];

  home.sessionVariables = {
    EDITOR = "hx";
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
        bufferline = "multiple";
        color-modes = true;
        true-color = true;
        auto-save = true;
        indent-guides = {
          render = true;
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "file-modification-indicator"
          ];
          center = [ "version-control" ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-type"
          ];
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
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
        };
      };
      keys.normal = {
        "H" = "goto_previous_buffer";
        "L" = "goto_next_buffer";
        "A-j" = [
          "extend_to_line_bounds"
          "delete_selection"
          "paste_after"
        ];
        "A-k" = [
          "extend_to_line_bounds"
          "delete_selection"
          "move_line_up"
          "paste_before"
        ];
        "A-J" = [
          "extend_to_line_bounds"
          "yank"
          "paste_after"
        ];
        "A-K" = [
          "extend_to_line_bounds"
          "yank"
          "paste_before"
        ];
        space = {
          space = ":reload-all";
          e = [
            ":sh rm -f /tmp/yazi-chooser"
            ":insert-output yazi \"%{buffer_name}\" --chooser-file=/tmp/yazi-chooser"
            ":sh printf '\\x1b[?1049h\\x1b[?2004h' > /dev/tty"
            ":open %sh{cat /tmp/yazi-chooser}"
            ":redraw"
            ":set mouse false"
            ":set mouse true"
          ];
          l = [
            ":sh rm -f /tmp/hx-lazygit-buffer"
            ":write-all"
            ":sh printf '%s' \"%{buffer_name}\" > /tmp/hx-lazygit-buffer"
            ":insert-output lazygit > /dev/tty"
            ":sh printf '\\x1b[?1049h\\x1b[?2004h' > /dev/tty"
            ":open %sh{cat /tmp/hx-lazygit-buffer}"
            ":redraw"
            ":reload-all"
            ":set mouse false"
            ":set mouse true"
          ];
        };
        ret.b = ":echo %sh{git blame -L %{cursor_line},+1 %{buffer_name}}";
        Z.Z = ":write-quit-all";
      };
    };
  };
}
