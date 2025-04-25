{ ... }:
{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };

  services.gnome.gnome-keyring.enable = true;
  services.flatpak.enable = true;

  programs.ssh.startAgent = true;

  programs.fish.enable = true;
  
  hardware.bluetooth.enable = true;
}
