{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.dev.java;
in {
  options.${namespace}.dev.java = {
    enable = mkBoolOpt false "Wheter to enable Rust language support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jetbrains.idea-ultimate
    ];

    programs.java = enabled;
  };
}
