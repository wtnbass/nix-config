{ pkgs, ... }:
let
  denoFmt = ext: extraArgs: {
    command = "deno";
    args = [
      "fmt"
      "--quiet"
      "--ext"
      ext
    ]
    ++ extraArgs
    ++ [ "-" ];
  };
in
{
  programs.helix.languages = {
    language-server.jdtls = {
      command = "jdtls";
      args = [
        "--jvm-arg=-javaagent:${pkgs.lombok}/share/java/lombok.jar"
      ];
    };
    language-server.vtsls = {
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
    language-server.tailwindcss-ls = {
      command = "tailwindcss-language-server";
      args = [ "--stdio" ];
    };
    language =
      map
        ({ name, ext }: {
          inherit name;
          language-servers = [
            "vtsls"
            "tailwindcss-ls"
          ];
          formatter = denoFmt ext [ ];
          auto-format = true;
        })
        [
          {
            name = "javascript";
            ext = "js";
          }
          {
            name = "jsx";
            ext = "jsx";
          }
          {
            name = "typescript";
            ext = "ts";
          }
          {
            name = "tsx";
            ext = "tsx";
          }
        ]
      ++
        map
          (name: {
            inherit name;
            language-servers = [
              "vscode-html-language-server"
              "tailwindcss-ls"
            ];
            formatter = denoFmt name [ ];
            auto-format = true;
          })
          [
            "html"
          ]
      ++
        map
          (name: {
            inherit name;
            language-servers = [
              "vscode-css-language-server"
              "tailwindcss-ls"
            ];
            formatter = denoFmt name [ ];
            auto-format = true;
          })
          [
            "css"
            "scss"
          ]
      ++
        map
          (name: {
            inherit name;
            language-servers = [ "vscode-json-language-server" ];
            formatter = denoFmt name [ ];
            auto-format = true;
          })
          [
            "json"
            "jsonc"
          ]
      ++ [
        {
          name = "markdown";
          language-servers = [ "markdown-oxide" ];
          formatter = denoFmt "md" [
            "--prose-wrap"
            "preserve"
          ];
          auto-format = true;
        }
        {
          name = "nix";
          language-servers = [ "nixd" ];
          formatter.command = "nixfmt";
          auto-format = true;
        }
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
        {
          name = "lua";
          language-servers = [ "lua-language-server" ];
          formatter.command = "stylua";
          auto-format = true;
        }
        {
          name = "go";
          language-servers = [ "gopls" ];
          auto-format = true;
        }
        {
          name = "rust";
          language-servers = [ "rust-analyzer" ];
          auto-format = true;
        }
        {
          name = "haskell";
          language-servers = [ "haskell-language-server" ];
          auto-format = true;
        }
        {
          name = "java";
          language-servers = [ "jdtls" ];
          auto-format = true;
        }
        {
          name = "php";
          language-servers = [ "intelephense" ];
          auto-format = true;
        }
      ];
  };
}
