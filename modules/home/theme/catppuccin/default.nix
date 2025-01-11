{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkOpt mkBoolOpt enabled;

  cfg = config.${namespace}.theme.catppuccin;
  gtkCfg = config.${namespace}.theme.gtk;
  isGnomeEnabled = config.${namespace}.dektop.gnome.enable;

  catppuccinAccents = [
    "rosewater"
    "flamingo"
    "pink"
    "mauve"
    "red"
    "maroon"
    "peach"
    "yellow"
    "green"
    "teal"
    "sky"
    "sapphire"
    "blue"
    "lavender"
  ];

  catppuccinFlavors = [
    "latte"
    "frappe"
    "macchiato"
    "mocha"
  ];
in {
  options.${namespace}.theme.catppuccin = with types; {
    enable = mkBoolOpt false "Whether or not to enable Nautilus file manager.";
    accent = mkOpt (enum catppuccinAccents) "blue" "An optional theme accent.";
    flavor = mkOpt (enum catppuccinFlavors) "macchiato" "An optional theme flavor.";
    package = mkOpt package {
      inherit (cfg) accent;
      variant = cfg.flavor;
    } "Theme package.";
  };

  config = mkIf cfg.enable {
    catppuccin = {
      enable = false;

      accent = cfg.accent;
      flavor = cfg.flavor;

      cursors = enabled;
      gtk = mkIf gtkCfg.enable {
        enable = true;
        gnomeShellTheme = isGnomeEnabled;
        icon = enabled;
      };
    };
  };
}
