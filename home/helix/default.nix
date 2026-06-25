{ pkgs, ... }:
{
  home.sessionVariables = {
    EDITOR = "hx";
  };

  home.packages = [
    pkgs.bash-language-server
    pkgs.docker-compose-language-service
    pkgs.dockerfile-language-server
    pkgs.gopls
    pkgs.haskell-language-server
    pkgs.jdt-language-server
    pkgs.kotlin-language-server
    pkgs.lua-language-server
    pkgs.markdown-oxide
    pkgs.nixd
    pkgs.nixfmt
    pkgs.intelephense
    pkgs.ruff
    pkgs.rust-analyzer
    pkgs.stylua
    pkgs.tombi
    pkgs.vscode-langservers-extracted
    pkgs.vtsls
    pkgs.yaml-language-server
    pkgs.yamlfmt
    pkgs.zls
  ];

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
          ];
          center = [ "version-control" ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
          ];
          separator = "|";
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
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
        # LSP の診断をコード行に表示する。各行の行末に hint 以上を簡易表示し、
        # カーソルが乗った行は warning 以上をインライン展開する。
        # 全行で詳細を展開したいなら inline-diagnostics.other-lines も "hint" にする。
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
    languages.language-server.vtsls = {
      command = "vtsls";
      args = [ "--stdio" ];
      config = {
        typescript = {
          tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
          preferences.importModuleSpecifier = "shortest";
        };
        javascript.preferences.importModuleSpecifier = "shortest";
        vtsls.autoUseWorkspaceTsdk = true;
      };
    };
    languages.language =
      map
        (name: {
          inherit name;
          language-servers = [ "vtsls" ];
        })
        [
          "typescript"
          "tsx"
          "javascript"
          "jsx"
        ]
      ++ [
        {
          name = "nix";
          language-servers = [ "nixd" ];
          formatter.command = "nixfmt";
          auto-format = true;
        }
        {
          name = "lua";
          language-servers = [ "lua-language-server" ];
          formatter.command = "stylua";
          auto-format = true;
        }
        {
          name = "markdown";
          language-servers = [ "markdown-oxide" ];
          formatter = {
            command = "deno";
            args = [
              "fmt"
              "--quiet"
              "--ext"
              "md"
              "--prose-wrap"
              "preserve"
              "-"
            ];
          };
          auto-format = true;
        }
      ]
      ++
        map
          (name: {
            inherit name;
            language-servers = [ "vscode-json-language-server" ];
            formatter = {
              command = "deno";
              args = [
                "fmt"
                "--quiet"
                "--ext"
                name
                "-"
              ];
            };
            auto-format = true;
          })
          [
            "json"
            "jsonc"
          ]
      ++ [
        {
          name = "toml";
          language-servers = [ "tombi" ];
          formatter = {
            command = "tombi";
            args = [
              "format"
              "--quiet"
              "--stdin-filename"
              "%{buffer_name}"
              "-"
            ];
          };
          auto-format = true;
        }
        {
          name = "yaml";
          language-servers = [ "yaml-language-server" ];
          formatter = {
            command = "yamlfmt";
            args = [ "-" ];
          };
          auto-format = true;
        }
      ];
  };
}
