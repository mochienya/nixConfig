{ pkgs, ... }:

{
  # awesome font!!
  fonts.fontconfig.enable = true;

  # i wanted to make this a derivation but the nunito repo needs some old version of a python library i can't get through nixpkgs
  home.file."/.local/share/fonts/truetype/Nunito/Nunito-VariableFont_wght.ttf".source =
    ../../assets/Nunito-VariableFont_wght.ttf;

  programs.plasma.fonts = {
    general = {
      family = "Nunito";
      pointSize = 10;
    };
    fixedWidth = {
      family = "MochieIosevka";
      pointSize = 10;
    };
    small = {
      family = "Nunito";
      pointSize = 8;
    };
    toolbar = {
      family = "Nunito";
      pointSize = 10;
    };
    menu = {
      family = "Nunito";
      pointSize = 10;
    };
    windowTitle = {
      family = "Nunito";
      pointSize = 10;
    };
  };

  home.pointerCursor = rec {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = name;
    };
  };

}
