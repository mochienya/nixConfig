extras@{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "Mon,Wed,Fri,Sun *-*-* 00:00:00";
    options = "--delete-old";
  };

  networking.hostName = extras.host;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false; # i HATE security!!!

  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.mochie = {
    isNormalUser = true;
    description = "mochie";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };
  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.nixPath = [ "nixpkgs=${extras.inputs.nixpkgs}" ];

  nix.settings = {
    trusted-users = [ "mochie" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  system.userActivationScripts = {
    # god forbid i open font manager to see what the full name of a font is
    homeManagerPleaseFix =
      let
        fontHell = "/home/mochie/.config/fontconfig/conf.d";
      in
      {
        text = ''
          rm -f ${fontHell}/10-hm-fonts.conf
        '';
      };
  };

  environment.systemPackages = with pkgs; [
    git
    ntfs3g
    ffmpeg-full
    yt-dlp
    qbittorrent
    equibop
    signal-desktop-bin
    rar
    wl-clipboard
  ];

  system.stateVersion = "25.05";
}
