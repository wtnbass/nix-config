{ pkgs, ... }:

let
  # プロジェクトが使うフォーマッタ(biome / prettier / oxfmt)を自動判定して整形する
  # ディスパッチャ。ローカルの node_modules/.bin を優先し、無ければここで注入した
  # Nix 版にフォールバックする。詳細は ./hx-fmt-dispatch.sh を参照。
  hx-fmt-dispatch = pkgs.writeShellApplication {
    name = "hx-fmt-dispatch";
    runtimeInputs = with pkgs; [
      biome
      prettier
      oxfmt
      jq
      coreutils
    ];
    text = builtins.readFile ./hx-fmt-dispatch.sh;
  };

  # auto-format を有効にし、上記ディスパッチャを通す言語 (JS/TS 系フル)。
  fmtLanguages = [
    "javascript"
    "jsx"
    "typescript"
    "tsx"
    "json"
    "jsonc"
    "json5"
    "css"
    "scss"
    "html"
    "vue"
    "svelte"
    "astro"
    "yaml"
    "graphql"
    "markdown"
  ];
  mkFmtLang = name: {
    inherit name;
    auto-format = true;
    formatter = {
      command = "${hx-fmt-dispatch}/bin/hx-fmt-dispatch";
      args = [ "%{buffer_name}" ];
    };
  };
in
{
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
        # LSP の診断をコード行に表示する。各行の行末に hint 以上を簡易表示し、
        # カーソルが乗った行は warning 以上をインライン展開する。
        # 全行で詳細を展開したいなら inline-diagnostics.other-lines も "hint" にする。
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
        };
      };
      keys.normal = {
        space = {
          space = ":reload-all";
          # space v を git/vcs 用サブメニューにする (space g は changed_file_picker のため避ける)。
          # v b: カーソル行の git blame をステータスラインに表示 (helix 25.07 の expansions)
          v.b = ":echo %sh{git blame -L %{cursor_line},+1 %{buffer_name}}";
        };
      };
    };
    languages.language = map mkFmtLang fmtLanguages;
    languages.language-server.typescript-language-server.config = {
      # nixpkgs の typescript-language-server は tsserver(typescript 本体) を同梱しないため、
      # プロジェクトに typescript が無くても LSP が動くよう Nix の tsserver を指す。
      # プロジェクトに node_modules/typescript があればそちらが優先される。
      tsserver.path = "${pkgs.typescript}/lib/node_modules/typescript/lib/tsserver.js";
      # 補完を確定すると import 文を自動挿入する (VSCode 同様の auto-import)。
      preferences = {
        includeCompletionsForModuleExports = true;
        includeCompletionsForImportStatements = true;
        # 挿入する import パスの形式: shortest / relative / non-relative / project-relative
        importModuleSpecifierPreference = "shortest";
      };
    };
  };
}
