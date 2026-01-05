{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      gamescope
      gamemode
    ];
  };
  services.flatpak = {
    enable = true;
    packages = [
      {
        appId = "org.vinegarhq.Sober";
        origin = "flathub";
      }
    ];
    update.onActivation = true;
    uninstallUnmanaged = true;
  };
  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraPkgs =
        ps: with ps; [
          umu-launcher
          gamescope
          gamemode
        ];
    })
    (prismlauncher.override {
      jdks = [ openjdk25 ];
      textToSpeechSupport = false;
    })
    protonup-rs
    r2modman
  ];

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = -10;
        inhibit_screensaver = 0;
      };
    };
  };
}
