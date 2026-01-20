{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kitty
    eza
    btop-cuda # literally identical to `btop` but it's compiled with autoAddDriverRunpath in buildInputs
    bat
    zoxide
    fzf
    fd
    ripgrep
    progress
    ouch
    ripdrag
  ];

  programs.zoxide.enable = true;
  programs.zoxide.options = [ "--cmd cd" ];
}
