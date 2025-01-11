{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.hardware.cpu.amd;
in {
  options.${namespace}.hardware.cpu.amd = {
    enable = mkBoolOpt false "Whether or not to enable support for AMD cpu.";
  };

  config = mkIf cfg.enable {
    boot = {
      extraModulePackages = [
        config.boot.kernelPackages.zenpower
      ];

      kernelModules = [
        "kvm-amd"
        "amd-pstate"
        "zenpower"
        "msr"
      ];

      kernelParams = ["amd_pstate=active"];
    };

    environment.systemPackages = with pkgs; [
      amdctl
    ];

    hardware.cpu.amd.updateMicrocode = true;
  };
}
