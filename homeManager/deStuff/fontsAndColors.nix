{ pkgs, ... }:

{
  # awesome font!!
  fonts.fontconfig.enable = true;
  home.file."/.local/share/fonts/Mochie_Iosevka/MochieIosevka-Regular.ttf".source =
    ../../files/MochieIosevka-Regular.ttf;

  home.file."/.local/share/fonts/Nunito/Nunito-VariableFont_wght.ttf".source =
    ../../files/Nunito-VariableFont_wght.ttf;

  home.packages = with pkgs; [
    nerd-fonts.symbols-only
    twitter-color-emoji
    texlivePackages.nunito
  ];

}
