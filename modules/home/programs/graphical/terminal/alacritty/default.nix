{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.programs.graphical.terminal.alacritty;
  catppuccinCfg = config.${namespace}.theme.catppuccin;
  fontMonoCfg = config.${namespace}.theme.font.mono;
in {
  options.${namespace}.programs.graphical.terminal.alacritty = with types; {
    enable = mkBoolOpt false "Whether enable to Alacritty.";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        window = {
          dimensions = {
            columns = 180;
            lines = 45;
          };
          padding = {
            x = 10;
            y = 10;
          };
          dynamic_padding = true;
          opacity = 0.85;
        };

        # max lines in buffer
        scrolling.history = 10000;

        # font config
        font = {
          normal = {
            family = fontMonoCfg.family;
            style = "Regular";
          };
          bold = {
            family = fontMonoCfg.family;
            style = "Bold";
          };
          italic = {
            family = fontMonoCfg.family;
            style = "Italic";
          };
          bold_italic = {
            family = fontMonoCfg.family;
            style = "Bold Italic";
          };
          size = fontMonoCfg.size;
        };

        # selection settings
        selection.save_to_clipboard = true;

        # cursor settings
        cursor = {
          style.shape = "Underline";
          unfocused_hollow = false;
        };

        # mouse settings
        mouse.bindings = [
          {
            mouse = "Middle";
            action = "PasteSelection";
          }
        ];

        # key bindings
        keyboard.bindings = [
          {
            key = "T";
            mods = "Control|Shift";
            action = "CreateNewWindow";
          }
          {
            key = "V";
            mods = "Control|Shift";
            action = "Paste";
          }
          {
            key = "C";
            mods = "Control|Shift";
            action = "Copy";
          }
        ];
      };
    };

    dconf.settings = {
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>c";
        command = "alacritty";
        name = "Open Terminal";
      };
    };

    catppuccin.alacritty = mkIf catppuccinCfg.enable enabled;

    ${namespace}.xdg.terminal = "Alacritty";
  };
}
