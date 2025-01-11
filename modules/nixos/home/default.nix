{
  config,
  options,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkAliasDefinitions types;
  inherit (lib.${namespace}) mkOpt enabled;
in {
  options.${namespace}.home = with types; {
    packages = mkOpt (listOf package) [] "A list of packages to be managed by home-manager's.";
    file = mkOpt attrs {} "A set of files to be managed by home-manager's.";
    config = mkOpt attrs {} "A set of files to be managed by home-manager's.";
    options = mkOpt attrs {} "Options to pass directly to home-manager.";
  };

  config = {
    ${namespace}.home.options = {
      home.file = mkAliasDefinitions options.${namespace}.home.file;
      home.stateVersion = config.system.stateVersion;

      xdg = {
        enable = true;
        portal = enabled;
        configFile = mkAliasDefinitions options.${namespace}.home.config;
      };

      programs.home-manager = enabled;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      verbose = true;
      backupFileExtension = "hm.backup";

      users.${config.${namespace}.user.name} = mkAliasDefinitions options.${namespace}.home.options;
    };
  };
}
