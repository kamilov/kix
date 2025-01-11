{
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkForce;
  inherit (lib.${namespace}) enabled;
in {
  imports = [
    ./hardware.nix
    ./disks.nix
  ];

  config = {
    boot = {
      kernelParams = ["resume_offset=533760"];
      supportedFilesystems = mkForce ["btrfs"];
      resumeDevice = "/dev/disk/by-label/os";

      initrd = {
        supportedFilesystems = ["nfs"];
        kernelModules = ["nfs"];
      };
    };

    ${namespace} = {
      hardware = {
        bluetooth = enabled;
        cpu.amd = enabled;
        gpu.amd = enabled;
        opengl = enabled;
        networking = enabled;
      };

      system.boot = {
        enable = true;
        plymouth = true;
        silent = true;
      };
      system.locale = {
        timeZone = "Europe/Moscow";
        locale = "ru_RU.UTF-8";
      };

      roles.desktop = enabled;
      desktop.gnome = enabled;

      virtualisation = {
        podman = enabled;
      };

      user = {
        name = "ramzych";
        fullName = "Ramazan Kamilov";
      };
    };

    system.stateVersion = "25.05";
  };
}
