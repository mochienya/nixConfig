{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kitty
    eza
    btop-cuda # literally identical to `btop` but it's compiled with autoAddDriverRunpath in buildInputs
    bat
    zoxide
    fzf
    yazi
    fd
    ripgrep
    progress
  ];

  programs.yazi = {
    enable = true;
    plugins = with pkgs.yaziPlugins; {
      inherit smart-filter;
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "F";
          run = "plugin smart-filter";
          desc = "Smart filter plugin";
        }
      ];
    };
  };

  programs.zoxide.enable = true;
  programs.zoxide.options = [ "--cmd cd" ];
}
