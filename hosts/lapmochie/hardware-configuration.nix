{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "uas"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5fc467ab-19db-4f64-820a-34417d8ad3d6";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2E26-1657";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.bluetooth.enable = true;

  # finger pint
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };
  services.fprintd.enable = true;

  # honestly scared of trying to use the dgpu in my laptop but the igpu can't decode 4k without frame drops
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    open = true;
    nvidiaSettings = true;
    prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
        offloadCmdMainProgram = "dgpu";
      };
    };
  };

  # trying to make it not run like shit (I HATE AGGRESSIVE POWER MANAGEMENT IN MODERN LAPTOPS!!)
  powerManagement.cpuFreqGovernor = "performance";
  services.throttled.enable = true;
  services.power-profiles-daemon.enable = false;
  environment.systemPackages = [ pkgs.auto-cpufreq ];
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      energy_performance_preference = "performance";
      energy_perf_bias = 0;
      turbo = "always";
    };
    battery = {
      governor = "powersave";
      energy_performance_preference = "balance_power";
      energy_perf_bias = 8;
      turbo = "never";
    };
  };
}
