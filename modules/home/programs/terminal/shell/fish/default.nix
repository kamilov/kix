{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkOpt mkBoolOpt enabled;

  cfg = config.${namespace}.programs.terminal.shell.fish;
in {
  options.${namespace}.programs.terminal.shell.fish = {
    enable = mkBoolOpt false "Whether enable to Fish shell.";
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
    };
  };
}
