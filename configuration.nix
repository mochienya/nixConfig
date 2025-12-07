extras@{ pkgs, ... }:

{
  imports = [
    ./homeManager/deStuff/iosevkaConfig.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = extras.host;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false; # i HATE security!!!

  networking.timeServers = [
    "0.pool.ntp.org"
    "1.pool.ntp.org"
    "2.pool.ntp.org"
    "3.pool.ntp.org"
  ];
  time.timeZone = null;
  services.automatic-timezoned.enable = true;
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
      "gamemode"
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

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "Mon,Wed,Fri,Sun *-*-* 00:00:00";
    options = "--delete-old";
  };


  nix.registry.master = {
    from = {
      type = "indirect";
      id = "master";
    };
    to = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "master";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    ntfs3g
    ffmpeg-full
    extras.master.yt-dlp
    qbittorrent
    signal-desktop
    rar
    wl-clipboard
  ];

  system.stateVersion = "25.05";
}
