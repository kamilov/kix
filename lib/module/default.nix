{lib, ...}: let
  inherit (lib) mkDefault mkForce mapAttrs mkOption types;
in rec {
  mkOpt = type: default: description:
    mkOption {inherit type default description;};

  mkOpt' = type: default:
    mkOpt type default null;

  mkBoolOpt = mkOpt types.bool;
  mkBoolOpt' = mkOpt' types.bool;

  enabled = {enable = true;};
  force-enabled = {enable = mkForce true;};
  disabled = {enable = false;};
  force-disabled = {enable = mkForce false;};

  boolToNum = bool:
    if bool
    then 1
    else 0;

  default-attrs = mapAttrs (_key: mkDefault);
  nested-default-attrs = mapAttrs (_key: default-attrs);

  force-attrs = mapAttrs (_key: mkForce);
  nested-force-attrs = mapAttrs (_key: force-attrs);
}
