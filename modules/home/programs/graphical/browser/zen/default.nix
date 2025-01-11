{
  config,
  inputs,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkOpt mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.browser.zen;
  catppuccinCfg = config.${namespace}.theme.catppuccin;
  package = inputs.zen-browser.packages.${pkgs.system}.default;
  jsonFormat = pkgs.formats.json {};
in {
  options.${namespace}.programs.graphical.browser.zen = with types; {
    enable = mkBoolOpt false "Whether enable to Zen browser.";
    profiles = mkOpt (attrsOf (submodule ({
      config,
      name,
      ...
    }: {
      options = {
        id = mkOpt ints.unsigned 0 "Profile unique ID.";
        name = mkOpt str name "Profile name.";
        path = mkOpt str name "Profile path.";
        isDefault = mkBoolOpt (config.id == 0) "Whether this is a default profile.";
        settings = mkOpt (attrsOf jsonFormat.type) {} "Profile settings";
        catppuccin = {
          enable = mkBoolOpt catppuccinCfg.enable "Whether enable to catppuccin theme in profile.";
          flavor = mkOpt str catppuccinCfg.flavor "Profile theme flavor.";
          accent = mkOpt str catppuccinCfg.accent "Profile theme accent.";
        };
      };
    }))) {} "The profiles configuration.";
  };

  imports = [
    ./settings.nix
  ];

  config = mkIf cfg.enable {
    home.packages = [
      package
    ];

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>b";
      command = "zen";
      name = "Open Browser";
    };

    ${namespace}.xdg.browser = "zen";
  };
}
