extras@{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kitty
    eza
    btop
    bat
    zoxide
    fzf
    yazi
    # starship
  ];

  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      direnv hook fish | source
      function nish
        begin
          set -l pkg $argv[1]
          set -lx NIXPKGS_ALLOW_UNFREE 1
          command nix shell --impure "nixpkgs#$pkg"
        end
      end
    '';
    preferAbbrs = false;
    shellAliases = {
      ls = "eza -1 -l -a -F --color=always --icons --no-permissions --no-user --no-time";
      nano = "micro";
      nrbs = "sudo nixos-rebuild switch --flake ~/nixConfig#${extras.host}";
      nfu = "nix flake update --flake ~/nixConfig";
      udrbsd = "nix flake update --flake ~/nixConfig && sudo nixos-rebuild switch --flake ~/nixConfig#${extras.host} && sudo shutdown now";
      grb = "sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old";
      newProj = "nix flake init --refresh -t github:mochienya/nix-dev-template";
    };
    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        src = autopair.src;
      }
      {
        name = "tide";
        src = tide.src;
      }
      {
        name = "colored-man-pages";
        src = colored-man-pages.src;
      }
    ];
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Mochie Iosevka";
      size = 16;
    };
    settings = {
      confirm_os_window_close = 0;
      wayland_titlebar_color = "background";
      enable_audio_bell = false;
      cursor_shape = "beam";
      tab_bar_edge = "bottom";
      shell = "fish";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
    };
    themeFile = "tokyo_night_night";
    keybindings = {
      "ctrl+shift+w" = "close_tab";
      "alt+1" = "goto_tab 1";
      "alt+2" = "goto_tab 2";
      "alt+3" = "goto_tab 3";
      "alt+4" = "goto_tab 4";
      "alt+5" = "goto_tab 5";
      "alt+6" = "goto_tab 6";
      "alt+7" = "goto_tab 7";
      "alt+8" = "goto_tab 8";
      "alt+9" = "goto_tab 9";
    };
  };

  # programs.starship = {
  #   enable = true;
  #   enableTransience = true;
  #   settings = {
  # writing a prompt is hard ok :(
  #   };
  # };

  programs.zoxide.enable = true;
  programs.zoxide.options = [ "--cmd cd" ];
}
