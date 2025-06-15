extras@{ inputs, pkgs, ... }:

{
  home = {
    username = "mochie";
    homeDirectory = "/home/mochie";
    stateVersion = "24.11";
  };
  programs.home-manager.enable = true;

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ./hmNixFiles/devStuff.nix
    ./hmNixFiles/cliStuff.nix
    ./deStuff/fontsAndColors.nix
  ];

  home.packages = with pkgs; [
    syncplay
    croc
    inputs.zen-browser.packages."${extras.system}".twilight
  ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${extras.system};
    in
    {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
        trashbin
        keyboardShortcut
        goToSong
        listPlaylistsWithSong
        history
        savePlaylists
        playNext
        volumePercentage
        playingSource
        beautifulLyrics
      ];
      enabledCustomApps = with spicePkgs.apps; [
        lyricsPlus
      ];
      # theme = spicePkgs.themes.text;
      # colorScheme = "TokyoNight";
    };
  programs.mpv = {
    enable = true;
    config = {
      input-default-bindings = false;
      input-builtin-bindings = false;
      sub-outline-color = "0.0/0.3";
      sub-border-style = "opaque-box";
      sub-outline-size = -2;
      sub-filter-regex-append = "opensubtitles\\.org";
      hidpi-window-scale = false;
      hwdec = "auto";
      profile = "high-quality";
      vo = "gpu-next";
      vulkan-swap-mode = "auto";
      gpu-context = "wayland";
      # osc = false;
      # title = "\$\{#media-title:\$\{!media-title==filename:\$\{media-title\} -- \}\}\$\{filename\}"; help
    };
    bindings = {
      "]" = "add speed 0.5";
      "[" = "add speed -0.5";
      SPACE = "cycle pause";
      RIGHT = "seek 5 exact";
      LEFT = "seek -5 exact";
      v = "cycle sub";
      V = "cycle sub down";
      b = "cycle audio";
      B = "cycle audio down";
      f = "cycle fullscreen";
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
      j = "playlist-prev";
      l = "playlist-next";
      "`" = "script-binding console/enable";
    };
    scripts = with pkgs.mpvScripts; [
      mpv-osc-tethys
      thumbfast
    ];
  };
}
