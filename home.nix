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
    extras.inputs.plasma-manager.homeManagerModules.plasma-manager
    ./homeManager/devStuff.nix
    ./homeManager/cliStuff.nix
    ./homeManager/mpv.nix
    ./homeManager/deStuff/fontsAndColors.nix
    ./homeManager/deStuff/kde.nix
  ];

  home.packages = with pkgs; [
    syncplay
    croc
    inputs.zen-browser.packages."${pkgs.system}".twilight
    inputs.copyparty.packages.${pkgs.system}.default
  ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
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

  xdg.desktopEntries.equibop = {
    name = "Equibop";
    exec = "${pkgs.equibop}/bin/equibop";
    icon = "${pkgs.equibop}/share/icons/hicolor/1024x1024/apps/equibop.png";
    comment = "used to talk to cassie :3";
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
  };
}
