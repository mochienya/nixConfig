{ pkgs, ... }:

{
  # awesome font!!
  fonts.fontconfig.enable = true;
  home.file."/.local/share/fonts/Iosevka_Custom/IosevkaCustom-Regular.ttf".source =
    ../homeManagerFiles/IosevkaCustom-Regular.ttf;

  home.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

}
