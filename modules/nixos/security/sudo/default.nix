{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkForce mkDefault getExe' types;
  inherit (lib.${namespace}) mkOpt mkBoolOpt;

  cfg = config.${namespace}.security.sudo;
in {
  options.${namespace}.security.sudo = with types; {
    enable = mkBoolOpt false "Whether enable to sudo.";
    file = mkOpt path null "Default sops file.";
    sshKeyPaths = mkOpt (listOf path) ["/etc/ssh/ssh_host_ed25519_key"] "SSH Key paths to use.";
  };

  config = mkIf cfg.enable {
    security.sudo = {
      enable = true;

      execWheelOnly = mkForce true;
      wheelNeedsPassword = mkDefault true;

      extraRules = let
        rules = with pkgs; [
          {
            package = coreutils;
            command = "sync";
          }
          {
            package = hdparm;
            command = "hdparm";
          }
          {
            package = nix;
            command = "nix-collect-garbage";
          }
          {
            package = nix;
            command = "nix-store";
          }
          {
            package = nixos-rebuild;
            command = "nixos-rebuild";
          }
          {
            package = nvme-cli;
            command = "nvme";
          }
          {
            package = systemd;
            command = "poweroff";
          }
          {
            package = systemd;
            command = "reboot";
          }
          {
            package = systemd;
            command = "shutdown";
          }
          {
            package = systemd;
            command = "systemctl";
          }
          {
            package = util-linux;
            command = "dmesg";
          }
        ];
        mkRule = rule: {
          command = getExe' rule.package rule.command;
          options = ["NOPASSWD"];
        };

        commands = map mkRule rules;
      in [
        {
          inherit commands;
          groups = ["wheel"];
        }
      ];
    };
  };
}
