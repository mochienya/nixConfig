{ pkgs, ... }:

{
  programs.steam.enable = true;

  services.flatpak = {
    enable = true;
    packages = [{ appId = "org.vinegarhq.Sober"; origin = "flathub"; }];
    update.onActivation = true;
    uninstallUnmanaged = true;
  };
}
