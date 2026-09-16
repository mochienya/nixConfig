args@{ pkgs, ... }:

{
  home = {
    username = "mochie";
    homeDirectory = "/home/mochie";
    stateVersion = "24.11";
  };
  programs.home-manager.enable = true;

  imports = [
    args.inputs.spicetify-nix.homeManagerModules.default
    ./home-manager/dev-stuff.nix
    ./home-manager/cli-stuff.nix
    ./home-manager/cli
    ./home-manager/mpv.nix
    ./home-manager/fonts-and-colors.nix
  ];

  home.packages = with args.pkgs; [
    syncplay
    ayugram-desktop
    nh
    gimp3
    mumble
    args.inputs.zen-browser.packages."${args.pkgs.stdenv.hostPlatform.system}".twilight
    (
      (args.pkgs.discord.override (old: {
        withOpenASAR = true;
        withEquicord = true;
        withTTS = false;
        enableAutoscroll = true;
        useFHSEnv = false;
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
      spicePkgs = args.inputs.spicetify-nix.legacyPackages.${args.pkgs.stdenv.hostPlatform.system};
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
