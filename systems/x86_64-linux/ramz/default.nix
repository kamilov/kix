{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [
    ./hardware.nix
    ./disks.nix
  ];

  config = {
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
