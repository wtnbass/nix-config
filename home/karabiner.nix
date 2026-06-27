{ ... }:

let
  commandToInputSourceRule = {
    description = "Use command keys alone as eisuu/kana";
    manipulators = [
      {
        type = "basic";
        from = {
          key_code = "left_command";
          modifiers.optional = [ "any" ];
        };
        to = [
          {
            key_code = "left_command";
            lazy = true;
          }
        ];
        to_if_alone = [
          {
            key_code = "japanese_eisuu";
          }
        ];
      }
      {
        type = "basic";
        from = {
          key_code = "right_command";
          modifiers.optional = [ "any" ];
        };
        to = [
          {
            key_code = "right_command";
            lazy = true;
          }
        ];
        to_if_alone = [
          {
            key_code = "japanese_kana";
          }
        ];
      }
    ];
  };

  escapeToEisuuRule = {
    description = "Use escape as escape and eisuu";
    manipulators = [
      {
        type = "basic";
        from = {
          key_code = "escape";
          modifiers.optional = [ "any" ];
        };
        to = [
          {
            key_code = "escape";
          }
          {
            key_code = "japanese_eisuu";
          }
        ];
      }
    ];
  };

  karabinerConfig = {
    global = {
      check_for_updates_on_startup = true;
      show_in_menu_bar = true;
      show_profile_name_in_menu_bar = false;
    };

    profiles = [
      {
        name = "Default profile";
        selected = true;
        simple_modifications = [
          {
            from.key_code = "caps_lock";
            to = [
              {
                key_code = "left_control";
              }
            ];
          }
        ];
        complex_modifications = {
          parameters = {
            "basic.simultaneous_threshold_milliseconds" = 50;
            "basic.to_delayed_action_delay_milliseconds" = 500;
            "basic.to_if_alone_timeout_milliseconds" = 1000;
            "basic.to_if_held_down_threshold_milliseconds" = 500;
          };
          rules = [
            commandToInputSourceRule
            escapeToEisuuRule
          ];
        };
      }
    ];
  };
in
{
  xdg.configFile."karabiner/karabiner.json" = {
    force = true;
    text = builtins.toJSON karabinerConfig;
  };
}
