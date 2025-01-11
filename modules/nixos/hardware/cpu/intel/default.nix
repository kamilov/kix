{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.hardware.cpu.intel;
in {
  options.${namespace}.hardware.cpu.intel = {
    enable = mkBoolOpt false "Whether or not to enable support for Intel cpu.";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelModules = [
        "kvm-intel"
        "i915"
      ];

      kernelParams = [
        "i915.fastboot=1"
        "enable_gvt=1"
      ];
    };

    hardware.cpu.intel.updateMicrocode = true;
  };
}
