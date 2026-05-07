args@{ pkgs, ... }:

{
  imports = [
    ./beamng.nix
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      gamemode
      mangohud
      # supposedly helps with beamng drive
      nss
      curl
    ];
    gamescopeSession = {
      enable = true;
      args = [
        "--max-scale"
        "1"
        "--backend"
        "sdl"
        "--force-windows-fullscreen"
        "--mangoapp"
        "--nested-unfocused-refresh"
        "5"
        "--fullscreen"
        "--expose-wayland"
      ]
      ++ (args.lib.optionals (args.host == "lapmochie") [
        "-W"
        "1920"
        "-H"
        "1200"
        "-w"
        "1920"
        "-h"
        "1200"
        "--nested-refresh"
        "60"
        "--prefer-output"
        "eDP-1"
        "--prefer-vk-device"
        "10de:28ba"
      ]);
    };
  };
  programs.gamescope.capSysNice = true;

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
    mangohud
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
