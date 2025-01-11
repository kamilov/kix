#!/usr/bin/env -S nix shell -i nixpkgs#nixos-install-tools nixpkgs#gnugrep nixpkgs#coreutils nixpkgs#util-linux nixpkgs#cryptsetup nixpkgs#btrfs-progs nixpkgs#dosfstools nixpkgs#parted nixpkgs#lvm2_dmeventd nixpkgs#bashInteractive -c bash

function usage {
  echo "Usage: $0"
  echo "    create - create disk partitions"
  echo "    mount  - mount disks"
}
