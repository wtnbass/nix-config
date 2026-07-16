{ pkgs, lib, ... }:

let
  # blocked な agent の terminal に順番にフォーカスを移す
  herdr-focus-blocked-agent = pkgs.writeShellApplication {
    name = "herdr-focus-blocked-agent";
    runtimeInputs = [
      pkgs.jq
      pkgs.llm-agents.herdr
    ];
    text = ''
      t=$(
        herdr agent list | jq -r '
          .result.agents as $a
          | [$a[] | select(.agent_status == "blocked").terminal_id] as $b
          | [$a[] | select(.focused).terminal_id][0] as $f
          | if $b == []
            then empty
            else $b[((($b | index($f)) // -1) + 1) % ($b | length)]
            end
        '
      )
      if [ -n "$t" ]; then
        herdr agent focus "$t"
      fi
    '';
  };
in
{
  programs.herdr = {
    enable = true;
    package = pkgs.llm-agents.herdr;
    settings = {
      reveal_hidden_cursor_for_cjk_ime = true;
      cjk_ime_agents = [
        "claude"
        "codex"
        "pi"
      ];
      cjk_ime_acursor_shape = "steady_block";
      switch_ascii_input_source_in_prefix = true;
      keys = {
        prefix = "alt+j";

        command = [
          {
            key = "prefix+a";
            type = "shell";
            command = lib.getExe herdr-focus-blocked-agent;
            description = "Focus blocked agent pane";
          }
          {
            key = "prefix+alt+l";
            type = "popup";
            command = "lazygit";
            width = "80%";
            height = "80%";
            description = "Popup lazygit";
          }
          {
            key = "prefix+alt+d";
            type = "popup";
            command = "lumen diff";
            width = "80%";
            height = "80%";
            description = "Popup lumen diff";
          }
        ];
      };
      ui = {
        prompt_new_tab_name = false;
      };
    };
  };
}
