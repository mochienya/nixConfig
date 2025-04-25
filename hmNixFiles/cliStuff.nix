{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kitty
    eza
    btop
    bat
    zoxide
    fzf
    yazi
  ];

  # things that should be added to $PATH
  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''set fish_greeting'';
    preferAbbrs = false;
    shellAliases = {
      cat = "bat";
      ls = "eza -1 -l -a -F --color=always --icons --no-permissions --no-user --no-time";
      nano = "micro";
      nrbs = "sudo nixos-rebuild switch --flake ~/nixConfig";
      nfu = "nix flake update --flake ~/nixConfig";
      udrbsd = "nix flake update --flake ~/nixConfig && sudo nixos-rebuild switch --flake ~/nixConfig && sudo shutdown now";
    };
    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        src = autopair;
      }
    ];
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Custom";
      size = 16;
    };
    settings = {
      confirm_os_windows_close = 0;
      enable_audio_bell = false;
      cursor_shape = "beam";
      tab_bar_edge = "top";
      shell = "fish";
      
    };

  };

  programs.zoxide.enable = true;
  programs.zoxide.options = [ "--cmd cd" ];
}
