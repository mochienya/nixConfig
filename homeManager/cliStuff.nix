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
  ];

  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    functions = {
      nish = {
        # line 2 is "prepend 'nixpkgs#' to every argument passed to the function"
        # fish is fun :3
        body = ''
          set -lx NIXPKGS_ALLOW_UNFREE 1
          set -l pkgs "github:NixOS/nixpkgs/nixos-unstable#"$argv
          command nix shell --impure (string join " " $pkgs)
        '';
      };
    };
    interactiveShellInit = ''
      set fish_greeting
      direnv hook fish | source
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
      symbol_map = "U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6AA,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F32F,U+F400-U+F4A9,U+F500-U+F8FF,U+F0001-U+F1AF0 Symbols Nerd Font Mono";
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
