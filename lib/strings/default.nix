{lib, ...}: let
  inherit (builtins) substring stringLength;
  inherit (lib) toUpper toLower concatStrings;
in {
  toUpperFirst = str: let
    firstChar = substring 0 1 str;
    otherChars = substring 1 (stringLength str) str;
  in
    concatStrings [(toUpper firstChar) otherChars];

  toLowerFirst = str: let
    firstChar = substring 0 1 str;
    otherChars = substring 1 (stringLength str) str;
  in
    concatStrings [(toLower firstChar) otherChars];
}
