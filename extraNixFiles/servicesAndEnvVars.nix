{ ... }:
{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };

  services.flatpak.enable = true;

  # TODO: fix this shi fr fr
  programs.ssh.startAgent = true;

  programs.fish.enable = true;

  hardware.bluetooth.enable = true;
}
