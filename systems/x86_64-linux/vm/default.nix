{
  pkgs,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkForce;
  inherit (lib.${namespace}) enabled;
in {
  imports = [
    ./hardware.nix
  ];

  networking.hostName = "vm";

  boot = {
    loader.systemd-boot.enable = mkForce false;
    loader.grub = {
      enable = true;
      device = "/dev/vda";
      useOSProber = false;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  ${namespace} = {
    roles.desktop = enabled;
    desktop.gnome = enabled;

    system = {
      fonts = enabled;
    };

    security = {
      gpg = enabled;
      sops = enabled;
      sudo = enabled;
    };
  };

  system.stateVersion = "24.11";
}
