args@{ pkgs, ... }:

{
  imports = [
    ./gpu.nix
    ./fs.nix
  ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };



  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd = {
    ryzen-smu.enable = true;
    updateMicrocode = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  fonts.fontconfig = {
    antialias = true;
    hinting.enable = false;
    subpixel.lcdfilter = "none";
  };

  networking.useDHCP = args.lib.mkDefault true;
  networking.interfaces.enp9s0.wakeOnLan.enable = true;

  hardware.bluetooth.enable = true;
}
