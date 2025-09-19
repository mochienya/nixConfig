{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
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
    supportedFilesystems = [ "ntfs" ];
  };

  # my second ntfs drive
  #   fileSystems."/mnt/windows" =
  #   { device = "/dev/disk-by-uuid/C47A48227A481418";
  #     fsType = "ntfs-3g";
  #     options = [ "rw" "uid=1000"];
  #   };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/7c4226d8-a60d-4fa3-940c-e5db45d79f95";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/B4B8-7650";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

  };

  swapDevices = [ ];
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp9s0.wakeOnLan.enable = true;

  hardware.bluetooth.enable = true;

  # not too fond of green gpu
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "nvidia"
    "modesetting"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    open = false;
  };
}
