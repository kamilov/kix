{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge types;
  inherit (lib.${namespace}) mkBoolOpt default-attrs disabled;

  cfg = config.${namespace}.system.boot;
in {
  options.${namespace}.system.boot = with types; {
    enable = mkBoolOpt false "Whether or not to enable booting.";
    plymouth = mkBoolOpt false "Whether or not to enable plymouth boot splash.";
    secure = mkBoolOpt false "Whether or not to enable secure boot.";
    silent = mkBoolOpt false "Whether or not to enable silent boot.";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        efibootmgr
        efitools
        efivar
        fwupd
      ];

      boot = {
        loader = {
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };

          generationsDir.copyKernels = true;

          systemd-boot = {
            enable = true;
            configurationLimit = 10;
            editor = false;
          };
        };

        tmp = default-attrs {
          useTmpfs = true;
          cleanOnBoot = true;
          tmpfsSize = "50%";
        };
      };

      services.fwupd = {
        enable = true;
        daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
      };
    }

    (mkIf cfg.plymouth {
      boot = {
        kernelParams = ["quiet"];
        plymouth = {
          enable = true;
        };
      };
    })

    (mkIf cfg.secure {
      environment.systemPackages = with pkgs; [
        sbctl
      ];

      boot = {
        loader.systemd-boot = disabled;
        lanzaboote = {
          enable = true;
          pkiBundle = "/etc/secureboot";
        };
      };
    })

    (mkIf cfg.silent {
      boot.kernelParams = [
        "quiet"
        "loglevel=3"
        "udev.log_level=3"
        "systemd.show_status=auto"
        "rd.systemd.show_status=auto"
        "vt.global_cursor_default=0"
      ];
    })
  ]);
}
