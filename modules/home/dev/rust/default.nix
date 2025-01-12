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

    environment.sessionVariables = {
      CARGO_HOME = "${config.hone.userDirectory}/.local/dev/cargo";
    };

    home.${namespace}.path = ["$CARGO_HOME/bin"];
  };
}
