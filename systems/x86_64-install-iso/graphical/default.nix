{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled force-disabled;
in {
  boot.loader = {
    systemd-boot = enabled;
    efi.canTouchEfiVariables = true;
  };

  networking.wireless = force-disabled;

  ${namespace} = {
    hardware = {
      networking = enabled;
    };

    roles.desktop = enabled;

    system = {
      fonts = enabled;
      locale = enabled;
      nix = enabled;
    };

    desktop.gnome = enabled;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "kix";
  };
}
