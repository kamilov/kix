{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf optionals;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.hardware.networking;
  package = pkgs.iptables-legacy;
  iptablesBin = package + "/bin/iptables";
in {
  options.${namespace}.hardware.networking = {
    enable = mkBoolOpt false "Enable networking.";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      inherit package;
      logReversePathDrops = true;
      extraCommands = ''
        ${iptablesBin} -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        ${iptablesBin} -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      '';
      extraStopCommands = ''
        ${iptablesBin} -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        ${iptablesBin} -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      '';
    };
    networking.networkmanager = {
      enable = true;
      connectionConfig = {
        "connection.mdns" = "2";
      };

      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-vpnc
      ];
      unmanaged =
        [
          "interface-name:br-*"
          "interface-name:rndis*"
        ]
        ++ optionals config.${namespace}.virtualisation.podman.enable ["interface-name:docker*" "interface-name:podman*"];
    };

    ${namespace}.user.extraGroups = ["networkmanager"];
  };
}
