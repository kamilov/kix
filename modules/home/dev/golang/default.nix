{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkOpt mkBoolOpt;

  cfg = config.${namespace}.dev.golang;
in {
  options.${namespace}.dev.golang = with types; {
    enable = mkBoolOpt false "Wheter to enable Go language support.";
    private = mkOpt (listOf str) [] "Private modules path.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jetbrains.goland
    ];

    programs.go = {
      enable = true;
      goBin = ".local/dev/go/bin";
      goPath = ".local/dev/go";
      goPrivate = cfg.private;
    };

    ${namespace}.path = ["$GOBIN"];
  };
}
