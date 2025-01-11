{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.hardware.gpu.amd;
in {
  options.${namespace}.hardware.gpu.amd = {
    enable = mkBoolOpt false "Whether or not to enable support for AMD gpu.";
    amdvlk = mkBoolOpt false "Whether or not to enable support for VLK support.";
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.kernelModules = ["amdgpu"];
      kernelModules = ["amdgpu"];
    };

    hardware.amdgpu.amdvlk = mkIf cfg.amdvlk {
      enable = true;
      package = pkgs.amdvlk;
      support32Bit = enabled;
    };

    hardware.graphics.extraPackages = with pkgs; [
      rocmPackages.clr
    ];

    services.xserver.videoDrivers = mkDefault [
      "modesetting"
      "amdgpu"
    ];

    ${namespace}.user.extraGroups = ["video"];
  };
}
