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

}
