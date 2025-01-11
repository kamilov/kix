{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault mkForce types concatStringsSep;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.system.locale;
in {
  options.${namespace}.system.locale = with types; {
    enable = mkBoolOpt false "Whether or not to enable locale configuration.";
    timeZone = mkOpt str "Europe/Moscow" "System time zone";
    defaultLocale = mkOpt str "en_US.UTF-8" "Default system locale";
    locale = mkOpt str "en_US.UTF-8" "Default system locale";
    xkbLayout = mkOpt (listOf str) ["us" "ru"] "Xserver keyboard layout";
  };

  config = mkIf cfg.enable {
    console = {
      font = "Lat2-Terminus16";
      keyMap = mkForce "us";
      useXkbConfig = true;
    };

    services.xserver.xkb = {
      layout = concatStringsSep "," cfg.xkbLayout;
      options = "grp:win_space_toggle";
    };

    i18n = {
      defaultLocale = mkDefault cfg.defaultLocale;
      extraLocaleSettings = {
        LC_ADDRESS = cfg.locale;
        LC_IDENTIFICATION = cfg.locale;
        LC_MEASUREMENT = cfg.locale;
        LC_MONETARY = cfg.locale;
        LC_NAME = cfg.locale;
        LC_NUMERIC = cfg.locale;
        LC_PAPER = cfg.locale;
        LC_TELEPHONE = cfg.locale;
        LC_TIME = cfg.locale;
      };
    };

    time.timeZone = cfg.timeZone;
  };
}
