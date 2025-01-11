{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkOpt mkBoolOpt;

  mkFontConfig = family: size:
    with types; {
      family = mkOpt str family "Font family name";
      size = mkOpt int size "Font size";
    };

  cfg = config.${namespace}.theme.font;
in {
  options.${namespace}.theme.font = {
    enable = mkBoolOpt false "Wheter to enable font configuration";
    common = mkFontConfig "Product Sans" 12;
    serif = mkFontConfig "Lexend" 12;
    mono = mkFontConfig "JetBrainsMono Nerd Font" 12;
    icons = mkFontConfig "Phosphor" 12;
    emoji = mkFontConfig "Noto Color Emoji" 12;
  };

  config = mkIf cfg.enable {
    fonts = {
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = ["${cfg.common.family} ${toString cfg.common.size}"];
          serif = ["${cfg.serif.family} ${toString cfg.serif.size}"];
          monospace = ["${cfg.mono.family} ${toString cfg.mono.size}"];
          emoji = ["${cfg.emoji.family} ${toString cfg.emoji.size}"];
        };
      };
    };
  };
}
