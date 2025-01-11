{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.virtualisation.podman;
in {
  options.${namespace}.virtualisation.podman = {
    enable = mkBoolOpt false "Whether or not to enable Podman.";
  };

  config = mkIf cfg.enable {
    boot.enableContainers = false;

    virtualisation.podman = {
      enable = true;

      autoPrune = {
        enable = true;
        flags = ["--all"];
        dates = "weekly";
      };

      defaultNetwork.settings.dns_enabled = true;
      dockerCompat = true;
      dockerSocket = enabled;
    };

    environment.systemPackages = with pkgs; [
      podman-compose
      podman-desktop
    ];

    ${namespace} = {
      user.extraGroups = ["docker" "podman"];
      home.options = {
        home.shellAliases = {
          "docker-compose" = "podman-compose";
        };
      };
    };
  };
}
