{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) types;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.user;
in {
  options.${namespace}.user = with types; {
    name = mkOpt str "kix" "The name to use for the user account.";
    fullName = mkOpt str "" "The full name of the user.";
    initialPassword = mkOpt str "kix" "The password if the user.";
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs {} "Extra options passed to users.users.<name>";
  };

  config = {
    assertions = [
      {
        assertion = cfg.name != "";
        message = "${namespace}.user.name must be set";
      }
    ];
    users = {
      mutableUsers = true;
      users.${cfg.name} =
        {
          inherit (cfg) name initialPassword;
          isNormalUser = true;
          description = cfg.fullName;
          home = "/home/${cfg.name}";
          extraGroups = ["wheel"] ++ cfg.extraGroups;
        }
        // cfg.extraOptions;
    };
  };
}
