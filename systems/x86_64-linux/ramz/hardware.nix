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

  networking.useDHCP = mkDefault true;
}
