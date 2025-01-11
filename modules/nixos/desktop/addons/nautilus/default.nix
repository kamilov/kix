{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.desktop.addons.nautilus;
in {
  options.${namespace}.desktop.addons.nautilus = {
    enable = mkBoolOpt false "Whether or not to enable Nautilus file manager.";
  };

  config = mkIf cfg.enable {
    services = {
      gvfs = enabled;
      udisks2 = enabled;
    };

    environment.systemPackages = with pkgs; [
      nautilus
    ];

    ${namespace}.home.options.dconf.settings = {
      "org/gnome/settings-daemon/plugins/media-keys" = {
        home = ["<Super>f"];
      };

      "org/gnome/nautilus/preferences" = {
        always-use-location-entry = true;
        show-create-link = true;
        show-delete-permanently = true;
      };

      "org/gnome/nautilus/icon-view" = {
        default-zoom-level = "small-plus";
      };

      "org/gtk/gtk4/settings/file-chooser" = {
        sort-directories-first = true;
        show-hidden = true;
      };
    };
  };
}
