{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.services.ollama;
  gpuCfg = config.${namespace}.gpu;
  acceleration =
    if gpuCfg.amd.enable
    then "rocm"
    else if gpuCfg.nvidia.enable
    then "cuda"
    else false;
in {
  options.${namespace}.services.ollama = {
    enable = mkBoolOpt false "Whether or not to enable Ollama support.";
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration = acceleration;
    };
  };
}
