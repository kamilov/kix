{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.dev.rust;
in {
  options.${namespace}.dev.rust = {
    enable = mkBoolOpt false "Wheter to enable Rust language support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cargo
      rustc
      rust-analyzer
      rustfmt

      jetbrains.rust-rover
    ];

    home.sessionVariables = {
      CARGO_HOME = "${config.home.homeDirectory}/.local/dev/cargo";
    };

    ${namespace}.path = ["$CARGO_HOME/bin"];
  };
}
