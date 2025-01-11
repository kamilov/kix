{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled disabled;

  cfg = config.${namespace}.desktop.gnome;
in {
  options.${namespace}.desktop.gnome = {
    enable = mkBoolOpt false "Whether or not to enable Gnome desktop environment.";
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;

        displayManager.gdm = enabled;
        desktopManager.gnome = enabled;

        excludePackages = with pkgs; [
          xterm
        ];
      };

      udev.packages = with pkgs; [
        gnome-settings-daemon
      ];

      gnome = {
        core-utilities = disabled;
        core-developer-tools = disabled;
      };
    };

    environment.gnome.excludePackages = with pkgs; [
      gnome-shell-extensions
    ];

    programs.dconf = enabled;

    ${namespace} = {
      desktop.addons = {
        nautilus = enabled;
      };

      home.options.xdg = {
        portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
          ];
          config.common.default = "*";
        };
      };
    };
  };
}
