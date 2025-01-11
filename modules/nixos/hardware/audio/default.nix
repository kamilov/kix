{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkBoolOpt mkOpt enabled force-disabled;

  cfg = config.${namespace}.hardware.audio;
in {
  options.${namespace}.hardware.audio = with types; {
    enable = mkBoolOpt false "Whether or not to common role config.";
    extraPackages = mkOpt (listOf package) [
      # pkgs.qjackctl
      # pkgs.easyeffects
      # pkgs.pulsemixer
      # pkgs.pavucontrol
      # pkgs.helvum
    ] "Additional packages to install.";
  };

  config = mkIf cfg.enable {
    security.rtkit = enabled;

    services.pulseaudio = force-disabled;

    services.pipewire = {
      enable = true;
      alsa = enabled;
      audio = enabled;
      jack = enabled;
      pulse = enabled;
      wireplumber = enabled;
    };

    environment.systemPackages = cfg.extraPackages;

    ${namespace}.user.extraGroups = ["audio"];
  };
}
