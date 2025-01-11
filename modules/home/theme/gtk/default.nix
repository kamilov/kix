{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault types optionals;
  inherit (lib.${namespace}) mkOpt mkBoolOpt enabled;

  cfg = config.${namespace}.theme.gtk;
  catppuccinCfg = config.${namespace}.theme.gtk;
  fontConfig = config.${namespace}.theme.font.common;
in {
  options.${namespace}.theme.gtk = with types; {
    enable = mkBoolOpt false "Whether or not to enable GTK apply theme.";
    cursor = {
      name = mkOpt str "Bibata-Modern-Ice" "The name of the cursor theme.";
      size = mkOpt int 24 "The size of the cursor.";
      package = mkOpt package pkgs.bibata-cursors "The package to use for the cursor theme.";
    };

    icons = {
      name = mkOpt str "Papirus-Dark" "The name of the icon theme.";
      package = mkOpt package (pkgs.papirus-icon-theme.override {
        color = "black";
      }) "The package to use for the icon theme.";
    };

    theme = {
      name = mkOpt str "Gruvbox-Green-Dark" "The name of the theme.";
      package = mkOpt package (pkgs.gruvbox-gtk-theme.override {
        colorVariants = ["dark"];
        themeVariants = ["green"];
        tweakVariants = ["macos"];
      }) "The package to use for the theme.";
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          glib
          gtk3.out
        ]
        ++ optionals (catppuccinCfg.enable == false) [
          cfg.cursor.package
          cfg.icons.package
          cfg.theme.package
        ];

      pointerCursor = mkDefault {
        inherit (cfg.cursor) name package size;
        x11 = enabled;
      };

      sessionVariables = mkDefault {
        GTK_USE_PORTAL = "true";
        CURSOR_THEME = mkDefault cfg.cursor.name;
      };
    };

    gtk = {
      enable = true;

      cursorTheme = mkDefault {
        inherit (cfg.cursor) name size package;
      };

      iconTheme = mkDefault {
        inherit (cfg.icons) name package;
      };

      theme = mkDefault {
        inherit (cfg.theme) name package;
      };

      font = {
        inherit (fontConfig) size;
        name = fontConfig.family;
      };

      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        extraConfig = ''
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintslight"
          gtk-xft-rgba="rgb"
        '';
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-button-images = 1;
        gtk-decoration-layout = "appmenu:none";
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;
        gtk-error-bell = 0;
        gtk-menu-images = 1;
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "appmenu:none";
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;
        gtk-error-bell = 0;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
      };
    };

    xdg.configFile = let
      gtk4Dir = "${cfg.theme.package}/share/themes/${cfg.theme.name}/gtk-4.0";
    in {
      "gtk-4.0/assets".source = mkDefault "${gtk4Dir}/assets";
    };

    xdg.systemDirs.data = let
      schema = pkgs.gsettings-desktop-schemas;
    in
      mkDefault [
        "${schema}/share/gsettings-schemas/${schema.name}"
      ];
  };
}
