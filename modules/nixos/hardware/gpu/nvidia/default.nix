{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault versionOlder;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.hardware.gpu.nvidia;

  stable = config.boot.kernelPackages.nvidiaPackages.stable;
  beta = config.boot.kernelPackages.nvidiaPackages.beta;

  package =
    if (versionOlder beta.version stable.version)
    then stable
    else beta;
in {
  options.${namespace}.hardware.gpu.nvidia = {
    enable = mkBoolOpt false "Whether or not to enable support for Nvidia.";
  };

  config = mkIf cfg.enable {
    boot.blacklistedKernelModules = ["nouveau"];

    environment.systemPackages = with pkgs; [
      nvfancontrol
      nvtopPackages.nvidia

      mesa

      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];

    hardware = {
      nvidia = mkIf (!config.${namespace}.hardware.gpu.amd.enable) {
        package = mkDefault package;
        modesetting = enabled;

        powerManagement = {
          enable = mkDefault true;
          finegrained = mkDefault false;
        };

        open = mkDefault true;
        nvidiaSettings = false;
        nvidiaPersistenced = true;
        forceFullCompositionPipeline = true;
      };

      graphics = {
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
        ];

        extraPackages32 = with pkgs.pkgsi686Linux; [
          nvidia-vaapi-driver
        ];
      };
    };

    ${namespace}.user.extraGroups = ["video"];
  };
}
