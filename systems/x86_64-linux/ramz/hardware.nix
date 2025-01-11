{
  config,
  lib,
  modulesPath,
  namespace,
  ...
}: let
  inherit (lib) mkDefault;
  inherit (lib.${namespace}) enabled;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "ext4"];
    initrd.kernelModules = ["amdgpu"];
    kernelModules = ["acpi_call" "amdgpu"];
    extraModulePackages = [];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4e1d99b9-26ad-420b-bc02-03ff599906df";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6724-2138";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/eda752bc-9dc1-4147-a15f-e4c793742611";}
  ];

  networking.useDHCP = mkDefault true;
}
