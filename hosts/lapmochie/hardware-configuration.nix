args@{ pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./fingerprint.nix
    ./fwupd.nix
    ./gpu.nix
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
  boot.kernelModules = [
    "kvm-intel"
    "coretemp"
  ];
  boot.extraModulePackages = [ ];

  boot.kernelPackages = args.pkgs.linuxPackagesFor args.inputs.nix-cachyos-kernel.packages.${args.pkgs.stdenv.hostPlatform.system}.linux-cachyos-latest-lto-x86_64-v4;

  # windows partition owo
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/4A5853EF5853D7F1";
    fsType = "ntfs";
    options = [
      "defaults"
      "uid=1000"
      "gid=1000"
      "umask=0022"
      "nofail"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5fc467ab-19db-4f64-820a-34417d8ad3d6";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "noatime"
      "compress=zstd:5"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2E26-1657";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  services.fstrim.enable = true;

  swapDevices = [ ];

  networking.useDHCP = args.lib.mkDefault true;

  nixpkgs.hostPlatform = args.lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = args.lib.mkDefault args.config.hardware.enableRedistributableFirmware;

  hardware.bluetooth.enable = true;
  services.hardware.bolt.enable = true;

  # trying to make it not run like shit (I HATE AGGRESSIVE POWER MANAGEMENT IN MODERN LAPTOPS!!)
  powerManagement.cpuFreqGovernor = "performance";
  services.throttled.enable = true;
  services.power-profiles-daemon.enable = false;
  environment.systemPackages = with args.pkgs; [
    (lm_sensors.override { sensord = true; })
    auto-cpufreq
  ];
  hardware.fancontrol = {
    # enable = true;
  };
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
      energy_performance_preference = "power";
      energy_perf_bias = 15;
      turbo = "never";
    };
  };
}
