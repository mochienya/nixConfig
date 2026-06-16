args@{ pkgs, ... }:

{
  imports = [
    ./home-manager/iosevka-config.nix
    ./modules/nix.nix
    ./hyprland
  ];

  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      configurationLimit = 20;
      theme = args.pkgs.sleek-grub-theme.override {
        withStyle = "dark";
        withBanner = "boobloader";
      };
    };
  };

  networking.hostName = args.host;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false; # i HATE security!!!
  networking.enableIPv6 = false;

  services.resolved.enable = true;

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  networking.timeServers = [
    "0.pool.ntp.org"
    "1.pool.ntp.org"
    "2.pool.ntp.org"
    "3.pool.ntp.org"
  ];
  time.timeZone = null;
  services.automatic-timezoned.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

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
    shell = args.pkgs.fish;
  };
  security.sudo.wheelNeedsPassword = false;

  # stop mouse from waking up my pc (i just need to breathe on it for it to register)
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c0a0", ATTR{power/wakeup}="disabled"
  '';

  environment.systemPackages = with args.pkgs; [
    git
    ffmpeg-full
    args.master.yt-dlp
    qbittorrent
    signal-desktop
    rar
    wl-clipboard

    # tmp for no internert wawa
  ] ++ (with args.master; [
    zig_0_16
    zls_0_16
  ]) ++ (with args.master.beam28Packages; [
    elixir_1_20
    elixir-ls
    expert
    erlang
    hex
    ex_doc
  ]);

  system.stateVersion = "25.05";
}
