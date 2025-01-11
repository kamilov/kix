{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mapAttrs types;
  inherit (lib.${namespace}) mkBoolOpt mkOpt enabled;

  phosphoriconsPackage = pkgs.${namespace}.phosphoricons;
  productSansPackage = pkgs.${namespace}.product-sans;

  cfg = config.${namespace}.system.fonts;
in {
  options.${namespace}.system.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to enable manage fonts.";
    packages = with pkgs;
      mkOpt (listOf package) [
        corefonts
        b612
        material-icons
        material-design-icons
        work-sans
        comic-neue
        inter
        lexend

        phosphoriconsPackage
        productSansPackage

        # emojis
        noto-fonts-color-emoji
        twemoji-color-font

        # nerd fonts
        nerd-fonts.caskaydia-cove
        nerd-fonts.iosevka
        nerd-fonts.monaspace
        nerd-fonts.symbols-only
        nerd-fonts.jetbrains-mono
      ] "Custom fonts.";
    default = mkOpt str "JetBrainsMono Nerd Font" "Default font name.";
  };

  config = mkIf cfg.enable {
    environment = {
      variables.LOG_ICONS = "true";

      systemPackages = with pkgs; [
        font-manager
        fontpreview
        smile
      ];
    };

    fonts = {
      packages = cfg.packages;
      enableDefaultPackages = true;

      fontconfig = {
        antialias = true;
        hinting = enabled;

        defaultFonts = let
          common = [
            "MonaspiceNe Nerd Font"
            "CaskaydiaCove Nerd Font Mono"
            "Iosevka Nerd Font"
            "Symbols Nerd Font"
            "Noto Color Emoji"
          ];
        in
          mapAttrs (_: fonts: fonts ++ common) {
            serif = ["Noto Serif"];
            sansSerif = ["Lexend"];
            emoji = ["Noto Color Emoji"];
            monospace = [
              "Source Code Pro Medium"
              "Source Han Mono"
            ];
          };
      };

      fontDir = {
        enable = true;
        decompressFonts = true;
      };
    };
  };
}
