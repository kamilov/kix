{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf types optionals;
  inherit (lib.${namespace}) mkBoolOpt mkOpt enabled nested-default-attrs;

  cfg = config.${namespace}.desktop.gnome;
  gtkCfg = config.${namespace}.theme.gtk;
  wallpapers = pkgs.${namespace}.wallpapers;
in {
  options.${namespace}.desktop.gnome = with types; {
    enable = mkBoolOpt false "Whether or not to enable Gnome Shell configuration.";
    appindicator = mkBoolOpt false "Whether or not to enable Appindicator extension.";
    wallpaper = mkOpt (nullOr str) "tetris.png" "Wallpaper";
    pinned = mkOpt (listOf str) [] "Pinned applications.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        loupe
        file-roller
        gnome-calculator
        gnome-disk-utility

        wallpapers

        gnomeExtensions.user-themes
      ]
      ++ optionals cfg.appindicator [gnomeExtensions.appindicator];

    dconf = {
      enable = true;

      settings =
        nested-default-attrs {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions =
              [
                "user-theme@gnome-shell-extensions.gcampax.github.com"
              ]
              ++ optionals cfg.appindicator [
                "appindicatorsupport@rgcjonas.gmail.com"
              ];
            favorite-apps = cfg.pinned;
          };

          "org/gnome/shell/app-switcher" = {
            current-workspace-only = true;
          };

          "org/gnome/shell/extensions/user-theme" = {
            inherit (gtkCfg.theme) name;
          };

          "org/gnome/desktop/inteface" = {
            color-scheme = "prefer-dark";
            cursot-theme = gtkCfg.cursor.name;
            cursor-size = gtkCfg.cursor.size;
            gtk-theme = gtkCfg.theme.name;
            icon-theme = gtkCfg.icons.name;
            font-name = "jetbrains";
            enable-hot-corners = true;

            # clock
            clock-show-seconds = false;
            clock-show-date = false;
            clock-show-weekday = false;
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = true;
            two-finger-scrolling-enabled = true;
          };

          "org/gnome/desktop/privacy" = {
            remember-recent-files = false;
          };

          "org/gnome/mutter" = {
            edge-tiling = true;
            experimental-features = ["scale-monitor-framebuffer"];
            dynamic-workspaces = true;
          };
        }
        // optionals (cfg.wallpaper != null) {
          "org/gnome/desktop/background" = {
            picture-options = "zoom";
            picture-uri-dark = "file:///${wallpapers}/share/wallpapers/${cfg.wallpaper}";
          };
        };
    };

    ${namespace} = {
      theme.gtk = enabled;
      xdg.files = "org.gnome.Nautilus";
      xdg.image = "org.gnome.Loupe";
      xdg.archive = "org.gnome.FileRoller";
    };
  };
}
