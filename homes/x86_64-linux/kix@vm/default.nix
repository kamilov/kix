{
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkForce;
  inherit (lib.${namespace}) enabled;
in {
  ${namespace} = {
    roles.workstation = enabled;

    theme = {
      catppuccin = enabled;
      gtk = enabled;
    };
  };
}
