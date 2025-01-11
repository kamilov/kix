{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.programs.terminal.direnv;
in {
  options.${namespace}.programs.terminal.direnv = {
    enable = mkBoolOpt false "Wheter to enable Direnv.";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;

      enableBashIntegration = true;

      nix-direnv = enabled;
    };
  };
}
