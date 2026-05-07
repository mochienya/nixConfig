extras@{ ... }:

{
  programs.hyprland.enable = true;

  home-manager.users.mochie =
    { config, ... }:
    {
      xdg.configFile."hypr" = {
        source = config.lib.file.mkOutOfStoreSymlink /home/mochie/nixConfig/hyprland/main;
        recursive = true;
      };
      xdg.configFile."hypr-host/host.conf".source =
        config.lib.file.mkOutOfStoreSymlink /home/mochie/nixConfig/hyprland/${extras.host}.conf;
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
