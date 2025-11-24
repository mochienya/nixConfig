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
    extras.inputs.plasma-manager.homeModules.plasma-manager
    ./homeManager/devStuff.nix
    ./homeManager/cliStuff.nix
    ./homeManager/cli
    ./homeManager/mpv.nix
    ./homeManager/deStuff/fontsAndColors.nix
    ./homeManager/deStuff/kde.nix
  ];

  home.packages = with pkgs; [
    syncplay
    croc
    ayugram-desktop
    nh
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
    inputs.copyparty.packages.${pkgs.stdenv.hostPlatform.system}.default
    (
      (pkgs.discord.override (old: {
        withOpenASAR = true;
        withEquicord = true;
        withTTS = false;
        enableAutoscroll = true;
      })).overrideAttrs
      (old: {
        # it's sometimes that shrimple..
        postInstall = old.postInstall + ''
          echo 'require ("/home/mochie/proj/equicord/dist/desktop/patcher.js")' > $out/opt/Discord/resources/app.asar/index.js
        '';
      })
    )
  ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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
      theme = spicePkgs.themes.text;
      colorScheme = "Spotify";
    };
}
