{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkForce types;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.roles.common;
in {
  options.${namespace}.roles.common = with types; {
    enable = mkBoolOpt false "Whether or not to common role config.";
  };

  config = mkIf cfg.enable {
    environment = {
      defaultPackages = mkForce [];
      systemPackages = with pkgs; [
        coreutils
        util-linux
        dnsutils
        rsync
        curl
        wget
        usbimager
      ];
    };

    ${namespace} = {
      hardware.networking = enabled;

      nix = enabled;

      system.locale = enabled;
    };
  };
}
