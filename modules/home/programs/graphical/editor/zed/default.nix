{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkOpt mkBoolOpt enabled;

  cfg = config.${namespace}.programs.graphical.editor.zed;
  fontFamilyDefaultCfg = config.${namespace}.theme.font.mono.family;
  catppuccinCfg = config.${namespace}.theme.catppuccin;
in {
  options.${namespace}.programs.graphical.editor.zed = with types; {
    enable = mkBoolOpt false "Whether enable to Zed Editor.";
    fontFamily = mkOpt str fontFamilyDefaultCfg "Editor font family.";
  };

  imports = [
    ./settings.nix
  ];

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
    };

    catppuccin.zed = mkIf catppuccinCfg.enable enabled;

    ${namespace}.xdg.editor = "dev.zed.Zed";
  };
}
