{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.nix;
in {
  options.${namespace}.nix = {
    enable = mkBoolOpt false "Whether or not to enable nix configuration.";
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        auto-optimise-store = mkDefault true;
        use-xdg-base-directories = true;
        warn-dirty = false;
        trusted-users = ["@wheel" "root"];
        experimental-features = ["nix-command" "flakes"];
        system-features = ["kvm" "big-parallel" "nixos-test"];
      };

      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
