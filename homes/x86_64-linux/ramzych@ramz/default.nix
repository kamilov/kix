{
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkDefault;
  inherit (lib.${namespace}) enabled;

  settings = import ./configs/zen/generated.nix // import ./configs/zen/settings.nix;
in {
  kix = {
    roles.workstation = enabled;

    desktop.gnome = {
      enable = true;
      appindicator = true;
    };

    theme = {
      font = enabled;
      catppuccin = enabled;
      gtk = enabled;
    };

    programs = {
      graphical = {
        browser.zen.profiles = {
          personal = {
            id = 0;
            name = "Main";
            path = "p_main";
            settings = settings;
          };

          work = {
            id = 1;
            name = "Work";
            path = "p_wb";
            settings = settings;
            catppuccin = {
              accent = "maroon";
            };
          };
        };
      };

      terminal = {
        git = {
          userName = "Ramazan Kamilov";
          userEmail = "i@ramzych.ru";
        };
      };
    };
  };
}
