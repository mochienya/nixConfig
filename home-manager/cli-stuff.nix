args@{ pkgs, ... }:

{
  home.packages = with args.pkgs; [
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
    wget2
    croc
    args.inputs.copyparty.packages.${args.pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.zoxide.enable = true;
  programs.zoxide.options = [ "--cmd cd" ];
}
