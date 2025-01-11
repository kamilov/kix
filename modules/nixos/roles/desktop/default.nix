{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.roles.desktop;
in {
  options.${namespace}.roles.desktop = with types; {
    enable = mkBoolOpt false "Whether or not to desktop role config.";
  };

  config.${namespace} = mkIf cfg.enable {
    roles.common = enabled;

    hardware.audio = enabled;

    system.fonts = enabled;

    security = {
      sudo = enabled;
    };
  };
}
