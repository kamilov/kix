{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.impermanence;
in {
  options.${namespace}.impermanence = {
    enable = mkBoolOpt false "Whether to enable impermanence.";
  };

  config = mkIf cfg.enable {
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    programs.fuse.userAllowOther = true;

    boot.initrd.systemd.services.rollback = {
      Description = "Rollback BTRFS root subvolume to a pristine state.";
      wantedBy = ["initrd.target"];
      after = ["systemd-cryptsetup@encrypted.service"];
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "snapshot";
      script = ''
        mkdir -p /mnt

        mount -o subvol=/ /dev/mapper/encrypted /mnt

        btrfs subvolume list -o /mnt |
          cut -f9 -d' ' |
          while read subvolume; do
            echo "deleting /$subvolume subvolume..."
            # btrfs subvolume delete /mnt/$subvolume
          done &&
          echo "restoring root subvolume"
          #btrfs subvolume delete /mnt/root
          #btrfs subvolume snapshot /mnt/root-blank /mnt/root

        umount /mnt
      '';

      environment.persistence."/persist" = {
        hideMounts = true;
        directories = [
          "/.cache/nix"
          "/etc/NetworkManager/system-connections"
          "/var/cache/"
          "/var/db/sudo/"
          "/var/lib/"
        ];
        files = [
          "/etc/machine-id"
          "/etc/ssh/ssh_host_ed25519"
          "/etc/ssh/ssh_host_ed25519.pub"
          "/etc/ssh/ssh_host_rsa"
          "/etc/ssh/ssh_host_rsa.pub"
        ];
      };
    };
  };
}
