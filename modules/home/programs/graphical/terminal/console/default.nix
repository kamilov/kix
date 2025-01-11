{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.terminal.console;
  fontMonoFamily = config.${namespace}.theme.font.mono.family;
in {
  options.${namespace}.programs.graphical.terminal.console = with types; {
    enable = mkBoolOpt false "Whether enable to Gnome Console.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome-console
    ];

    dconf.settings = {
      "org/gnome/Console" = {
        audible-bell = false;
        visual-bell = false;
        ignore-scrollback-limit = true;
        custom-font = fontMonoFamily;
        theme = "night";
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>c";
        command = "kgx";
        name = "Open Terminal";
      };
    };

    ${namespace}.xdg.terminal = "org.gnome.Console";
  };
}
