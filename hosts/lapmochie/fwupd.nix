args@{ ... }:

{
  services.fwupd = {
    enable = true;
    package = args.options.services.fwupd.package.default.override { enableFlashrom = true; };
    uefiCapsuleSettings = {
      ScreenWidth = 1920;
      ScreenHeight = 1200;
    };
  };
}
