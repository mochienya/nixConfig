args@{ pkgs, ... }:

{
  # awesome font!!
  fonts.fontconfig.enable = true;

  # i wanted to make this a derivation but the nunito repo needs some old version of a python library i can't get through nixpkgs
  home.file."/.local/share/fonts/truetype/Nunito/Nunito-VariableFont_wght.ttf".source =
    ../assets/Nunito-VariableFont_wght.ttf;

  home.pointerCursor = rec {
    enable = true;
    hyprcursor.enable = true;
    package = args.pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = name;
    };
  };

}
