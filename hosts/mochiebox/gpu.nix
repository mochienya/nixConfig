args@{ pkgs, ...}:

{
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
    package = args.config.boot.kernelPackages.nvidiaPackages.legacy_580;
    open = false;
  };
}
