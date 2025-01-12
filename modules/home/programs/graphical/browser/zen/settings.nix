{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (builtins) toJSON;
  inherit (lib) mkIf mkMerge isBool isInt isString mapAttrsToList nameValuePair concatStrings flip mapAttrs';
  inherit (lib.generators) toINI;
  inherit (lib.${namespace}) toUpperFirst;

  cfg = config.${namespace}.programs.graphical.browser.zen;
  cfgPath = ".zen";
  catppuccinCfg = config.${namespace}.theme.catppuccin;
  profiles =
    flip mapAttrs' cfg.profiles (_: profile:
      nameValuePair "Profile${toString profile.id}" {
        IsRelative = 1;
        Name = profile.name;
        Path = profile.path;
        Default =
          if profile.isDefault
          then 1
          else 0;
        ZenAvatarPath = "chrome://browser/content/zen-avatars/avatar-57.svg";
      })
    // {
      General = {
        StartWithLastProfile = 1;
        Version = 1;
      };
    };
  themeFile = flavor: accent: file: let
    catppuccinTheme = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "zen-browser";
      rev = "b048e8b";
      hash = "sha256-SoaJV83rOgsQpLKO6PtpTyKFGj75FssdWfTITU7psXM=";
    };
  in "${catppuccinTheme + "/themes/${toUpperFirst flavor}/${toUpperFirst accent}/${file}"}";

  userSettingsValue = value: let
    value' =
      if isBool value || isInt value || isString value
      then value
      else toJSON value;
  in
    toJSON value';

  userSettings = settings: ''
    // Generated config

    ${concatStrings (mapAttrsToList (name: value: ''
        user_pref("${name}", ${userSettingsValue value});
      '')
      settings)}
  '';
in {
  config = mkIf cfg.enable {
    home.file = mkMerge ([
        {
          "${cfgPath}/profiles.ini" = mkIf (cfg.profiles != {}) {
            text = toINI {} profiles;
            force = true;
          };
        }
      ]
      ++ flip mapAttrsToList cfg.profiles (_: profile: {
        "${cfgPath}/${profile.path}/user.js" = mkIf (profile.settings != {}) {
          text = userSettings (profile.settings
            // {
              "app.update.auto" = false;
              "app.update.checkInstallTime" = false;
            });
          force = true;
        };

        "${cfgPath}/${profile.path}/chrome/userChrome.css" = mkIf (profile.catppuccin.enable && catppuccinCfg.enable) {
          source = themeFile profile.catppuccin.flavor profile.catppuccin.accent "userChrome.css";
          force = true;
        };

        "${cfgPath}/${profile.path}/chrome/userContent.css" = mkIf (profile.catppuccin.enable && catppuccinCfg.enable) {
          source = themeFile profile.catppuccin.flavor profile.catppuccin.accent "userContent.css";
          force = true;
        };

        "${cfgPath}/${profile.path}/chrome/zen-logo-${profile.catppuccin.flavor}.svg" = mkIf (profile.catppuccin.enable && catppuccinCfg.enable) {
          source = themeFile profile.catppuccin.flavor profile.catppuccin.accent "zen-logo-${profile.catppuccin.flavor}.svg";
          force = true;
        };
      }));
  };
}
