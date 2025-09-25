{ pkgs, ... }:
let

  mochieIosevka = pkgs.stdenv.mkDerivation {
    name = "MochieIosevka";
    version = "1.0";

    src = ../../files;

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp -R ./MochieIosevka $out/share/fonts/truetype/MochieIosevka/
    '';
  };
in
{
  # awesome font!!
  fonts.fontconfig.enable = true;

  home.file."/.local/share/fonts/truetype/Nunito/Nunito-VariableFont_wght.ttf".source =
    ../../files/Nunito-VariableFont_wght.ttf;

  home.packages = with pkgs; [
    nerd-fonts.symbols-only
    twitter-color-emoji
    mochieIosevka
  ];

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
