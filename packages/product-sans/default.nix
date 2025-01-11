{
  stdenvNoCC,
  lib,
  ...
}: let
  inherit (lib.licenses) unfree;
  inherit (lib.platforms) all;
in
  stdenvNoCC.mkDerivation {
    pname = "product-sans";
    version = "1.0";

    src = ./ttf;

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      install -Dm644 *.ttf $out/share/fonts/truetype
    '';

    meta = {
      description = "Product Sans is a proprietary font made by Google.";
      homepage = "https://befonts.com/product-sans-font.html";
      license = unfree;
      platforms = all;
    };
  }
