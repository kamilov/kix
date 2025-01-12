{
  config,
  lib,
  pkgs,
  namepsace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namepsace}) mkOpt mkBoolOpt;

  cfg = config.${namepsace}.dev.golang;
in {
  options.${namepsace}.dev.golang = with types; {
    enable = mkBoolOpt false "Wheter to enable Go language support.";
    enableIde = mkBoolOpt true "Enable JetBrains IDE support for golang.";
    private = mkOpt (listOf str) "Private modules path.";
  };

  config = mkIf cfg.enable {
    home.packages = mkIf cfg.enableIde (with pkgs; [
      jetbrains.goland
    ]);

    home.programs.go = {
      enable = true;
      goBin = ".local/dev/go/bin";
      goPath = ".local/dev/go";
      goPrivate = cfg.private;
    };

    home.${namepsace}.path = ["$GOBIN"];
  };
}
