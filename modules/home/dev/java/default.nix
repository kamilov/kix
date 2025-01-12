{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (builtins) toPath;
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.dev.java;
in {
  options.${namespace}.dev.java = {
    enable = mkBoolOpt false "Wheter to enable Rust language support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jetbrains.idea-ultimate
    ];

    programs.java = {
      enable = true;
      package = pkgs.jdk.overrideAttrs {
        home = toPath "${config.user.homeDirectory}/.local/dev/jdk";
      };
    };
  };
}
