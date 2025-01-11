let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;

  inherit (builtins) map fromTOML;
  inherit (lib) mkMerge fileContents;

  themes = ["frappe" "latte" "macchiato" "mocha"];
  mkCatppuccinThemeSettings = name: let
    catppuccinThemeSource = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "starship";
      rev = "e99ba6b";
      hash = "sha256-1w0TJdQP5lb9jCrCmhPlSexf0PkAlcz8GBDEsRjPRns=";
    };
    themeFile = catppuccinThemeSource + "/themes/${name}.toml";
  in
    fromTOML (fileContents themeFile);

  catppuccinPalettes = mkMerge (map mkCatppuccinThemeSettings themes);

  result = catppuccinPalettes;
in
  result
