{
  lib,
  stdenvNoCC,
  ...
}: let
  inherit (builtins) map attrNames readDir baseNameOf;
  inherit (lib) foldl;
  inherit (lib.snowfall.path) get-file-name-without-extension;

  source = attrNames (readDir ./images);
  names = map get-file-name-without-extension source;
  mkWallpaper = name: src: let
    fileName = baseNameOf src;
    pkg = stdenvNoCC.mkDerivation {
      inherit name src;

      dontUnpack = true;

      installPhase = ''
        cp $src $out
      '';

      passthru = {inherit fileName;};
    };
  in
    pkg;

  target = "$out/share/wallpapers";
  wallpapers = foldl (acc: image: let
    name = get-file-name-without-extension image;
  in
    acc // {"${name}" = mkWallpaper name (./images + "/${image}");}) {}
  source;
in
  stdenvNoCC.mkDerivation {
    name = "wallpappers";
    src = ./images;

    installPhase = ''
      mkdir -p ${target};

      find * -type f -mindepth 0 -maxdepth 0 -exec cp ./{} ${target}/{} ';'
    '';

    passthru = {inherit names;} // wallpapers;
  }
