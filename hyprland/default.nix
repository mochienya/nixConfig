args@{ pkgs, ... }:

{
  # packages hyprland config uses
  environment.systemPackages = with args.pkgs; [
    satty
    grim
    playerctl
  ];

  programs.hyprland = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with args.pkgs; [
      xdg-desktop-portal-termfilechooser
      # xdg-desktop-portal-gtk
    ];
    config.common = {
      "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
      "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
      default = [ "hyprland" "gtk" ];
    };
  };
  

  home-manager.users.mochie =
    { config, ... }:
    {
      xdg.configFile."hypr" = {
        source = config.lib.file.mkOutOfStoreSymlink /home/mochie/nixConfig/hyprland/main;
        recursive = true;
      };
      xdg.configFile."hypr-host/host.conf".source =
        config.lib.file.mkOutOfStoreSymlink /home/mochie/nixConfig/hyprland/${args.host}.conf;
    };

  services.displayManager.ly.enable = true;

  programs.dms-shell = {
    enable = true;
    enableVPN = false;
    enableSystemMonitoring = false;
    enableDynamicTheming = false;
    enableCalendarEvents = false;
    enableAudioWavelength = false;
  };
}
