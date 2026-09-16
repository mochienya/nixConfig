args@{ pkgs, ... }:

{
  imports = [
    ./gpu.nix
    ./fs.nix
    ./audio.nix
    ./vr.nix
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

  boot.kernelPackages = args.pkgs.linuxPackagesFor args.inputs.nix-cachyos-kernel.packages.${args.pkgs.stdenv.hostPlatform.system}.linux-cachyos-latest-lto-x86_64-v3;

  environment.systemPackages = with args.pkgs; [
    v4l-utils
  ];

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    package = args.options.programs.obs-studio.package.default.override { cudaSupport = true; };
    plugins = with args.pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="video4linux", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="085c", RUN+="${args.pkgs.v4l-utils}/bin/v4l2-ctl -d $devnode --set-ctrl=power_line_frequency=1"
  '';

  nixpkgs.hostPlatform = "x86_64-linux";

  hardware.enableRedistributableFirmware = true;

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
