args@{ pkgs, ... }:

{
  services.monado = {
    enable = true;
    package = args.pkgs.monado.override { enableCuda = true; };
  };

  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "true";
    LH_OVERRIDE_IPD_MM = "68.5";
    VP2_RESOLUTION = "2";
    VP2_DEFAULT_BRIGHTNESS = "1.0";
    VP2_NOISE_CANCELLING = "false";
    XRT_COMPOSITOR_FORCE_WAYLAND_DIRECT = "1";
    XRT_COMPOSITOR_FORCE_NVIDIA = "0";
    XRT_COMPOSITOR_FORCE_SRGB = "1";
  };

  programs.steam.package = args.pkgs.steam.override {
    extraProfile = ''
      export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
      unset TZ
    '';
  };

  home-manager.users.mochie =
    hm@{ ... }:
    {
      xdg.configFile = {
      "openxr/1/active_runtime.json".source =
        "${args.config.services.monado.package}/share/openxr/1/openxr_monado.json";
      "openvr/openvrpaths.vrpath".text =
        let
          steam = "${hm.config.xdg.dataHome}/Steam";
        in
        builtins.toJSON {
          version = 1;
          jsonid = "vrpathreg";
          external_drivers = null;
          config = [ "${steam}/config" ];
          log = [ "${steam}/logs" ];
          runtime = [ "${args.pkgs.xrizer}/lib/xrizer" ];
        };
      };
    };

  # 0bb4 = HTC
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", MODE="0666", TAG+="uaccess"
  '';

  hardware.steam-hardware.enable = true;

  environment.systemPackages = with args.pkgs; [
    xrizer
    openxr-loader
    wayvr
  ];

}
