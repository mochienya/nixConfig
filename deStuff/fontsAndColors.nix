{ pkgs, ... }:

{
  # awesome font!!
  fonts.fontconfig.enable = true;
  home.file."/.local/share/fonts/Mochie_Iosevka/MochieIosevka-Regular.ttf".source =
    ../homeManagerFiles/MochieIosevka-Regular.ttf;

  home.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

}
