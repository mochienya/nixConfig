extras@{ pkgs, ... }:

{
  imports = [
    ./homeManager/deStuff/iosevkaConfig.nix
    ./modules/nix.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      configurationLimit = 10;
      theme = pkgs.sleek-grub-theme.override {
        withStyle = "dark";
        withBanner = "boobloader";
      };
    };
  };

  networking.hostName = extras.host;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false; # i HATE security!!!
  networking.enableIPv6 = false;

  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
    "1.0.0.1"
    "8.8.4.4"
  ];

  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
    "net.core.rmem_max" = 4194304;
    "net.core.wmem_max" = 4194304;
    "net.core.somaxconn" = 4096;
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1" "1.0.0.1" ];
  };

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

  environment.systemPackages = with pkgs; [
    git
    ffmpeg-full
    extras.master.yt-dlp
    qbittorrent
    signal-desktop
    rar
    wl-clipboard
  ];

  system.stateVersion = "25.05";
}
