args@{ pkgs, ... }:

{
  # igpu improvement(?)
  hardware.graphics = {
    enable = true;
    extraPackages = with args.pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
    extraPackages32 = with args.pkgs.driversi686Linux; [
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
    package = args.config.boot.kernelPackages.nvidiaPackages.latest;
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

  # stolen from https://github.com/TLATER/dotfiles/blob/master/nixos-modules/nvidia/prime.nix
  # services.udev.packages =
  #   let
  #     pciPath =
  #       busId:
  #       let
  #         components = args.lib.drop 1 (args.lib.splitString ":" busId);
  #         toHex = i: args.lib.toLower (args.lib.toHexString (args.lib.toInt i));

  #         domain = "0000"; # Apparently the domain is practically always set to 0000
  #         bus = args.lib.fixedWidthString 2 "0" (toHex (builtins.elemAt components 0));
  #         device = args.lib.fixedWidthString 2 "0" (toHex (builtins.elemAt components 1));
  #         function = builtins.elemAt components 2; # The function is supposedly a decimal number
  #       in
  #       "dri/by-path/pci-${domain}:${bus}:${device}.${function}-card";

  #     pCfg = args.config.hardware.nvidia.prime;
  #     igpuPath = pciPath pCfg.intelBusId;
  #     dgpuPath = pciPath pCfg.nvidiaBusId;
  #   in
  #   args.lib.singleton (
  #     args.pkgs.writeTextDir "args.lib/udev/rules.d/61-gpu-offload.rules" ''
  #       SYMLINK=="${igpuPath}", SYMLINK+="dri/igpu1"
  #       SYMLINK=="${dgpuPath}", SYMLINK+="dri/dgpu1"
  #     ''
  #   );

  # egpu!! (rip pascal series...)
  specialisation."egpu".configuration = {
    system.nixos.tags = [ "egpu" ];

    hardware.nvidia = {
      powerManagement.enable = args.lib.mkForce false;
      powerManagement.finegrained = args.lib.mkForce false;
      open = args.lib.mkForce false;
      package = args.lib.mkForce args.config.boot.kernelPackages.nvidiaPackages.production;
      nvidiaSettings = args.lib.mkForce true;
      nvidiaPersistenced = true;
      prime = {
        nvidiaBusId = args.lib.mkForce "PCI:6:0:0";
        allowExternalGpu = args.lib.mkForce true;
        # TODO: pr nixpkgs so this uses your configured nvidia gpu and not just the first one
        offload.enableOffloadCmd = args.lib.mkForce false;
      };
    };

    environment.systemPackages = [
      (args.pkgs.writeShellScriptBin "dgpu" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G1
        export args.__GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@"
      '')
    ];
  };
}
