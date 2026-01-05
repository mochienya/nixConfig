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

  # igpu improvement(?)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      intel-media-driver
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  # honestly scared of trying to use the dgpu in my laptop but the igpu can't decode 4k without frame drops
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
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

  services.hardware.bolt.enable = true;

  # egpu!! (rip pascal series...)
  specialisation."egpu".configuration = {
    system.nixos.tags = [ "egpu" ];

    hardware.nvidia = {
      powerManagement.enable = lib.mkForce false;
      powerManagement.finegrained = lib.mkForce false;
      open = lib.mkForce false;
      package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.production;
      nvidiaSettings = lib.mkForce true;
      nvidiaPersistenced = true;
      prime = {
        nvidiaBusId = lib.mkForce "PCI:5:0:0";
        allowExternalGpu = lib.mkForce true;
        # TODO: pr nixpkgs so this uses your configured nvidia gpu and not just the first one
        offload.enableOffloadCmd = lib.mkForce false;
      };
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "dgpu" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G1
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@"
      '')
    ];
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
      energy_performance_preference = "power";
      energy_perf_bias = 15;
      turbo = "never";
    };
  };
}
