{
  stdenvNoCC,
  lib,
  ...
}: let
  inherit (lib.licenses) mit;
  inherit (lib.platforms) all;
in
  stdenvNoCC.mkDerivation {
    pname = "phosphoricons";
    version = "2.1";

    src = ./ttf;

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      install -Dm644 *.ttf $out/share/fonts/truetype
    '';

    meta = {
      description = "Phosphor is a flexible icon family for interfaces, diagrams, presentations — whatever, really.";
      homepage = "https://phosphoricons.com";
      license = mit;
      platforms = all;
    };
  }
