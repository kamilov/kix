{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf getExe' types;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.security.gpg;
in {
  options.${namespace}.security.gpg = with types; {
    enable = mkBoolOpt false "Whether enable to GPG.";
    enableSSHSupport = mkBoolOpt false "Whether or not to enable SSH support for GPG.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cryptsetup
      gnupg
      paperkey
      pinentry-gnome3
    ];

    ${namespace}.home.file.".gnupg/gpg-agent.coonf".text = ''
      enable-ssh-support
      default-cache-ttl 60
      max-cache-ttl 120
      pinentry-program ${getExe' pkgs.pinentry-gnome3 "pinentry-gnome3"}
    '';

    programs = {
      ssh.startAgent = !cfg.enableSSHSupport;
      gnupg.agent = {
        inherit (cfg) enableSSHSupport;
        enable = true;
        enableExtraSocket = true;
        pinentryPackage = pkgs.pinentry-gnome3;
      };
    };

    services.pcscd = enabled;
  };
}
