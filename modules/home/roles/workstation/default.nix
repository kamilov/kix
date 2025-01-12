{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.roles.workstation;
in {
  options.${namespace}.roles.workstation = {
    enable = mkBoolOpt false "Whether or not to desktop workstation config.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tmux

      jetbrains.phpstorm

      telegram-desktop
    ];

    ${namespace} = {
      dev = {
        golang = enabled;
        java = enabled;
        rust = enabled;
      };

      programs = {
        graphical = {
          browser.zen = enabled;
          editor.zed = enabled;
          terminal.alacritty = enabled;
        };
        terminal = {
          direnv = enabled;
          git = enabled;
          shell.bash = enabled;
          starship = enabled;
        };
      };
    };
  };
}
