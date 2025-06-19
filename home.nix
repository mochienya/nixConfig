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
    ./hmNixFiles/mpv.nix
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
}
