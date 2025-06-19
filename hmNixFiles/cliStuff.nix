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
    direnv
    devenv
  ];

  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
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
      cat = "bat";
      ls = "eza -1 -l -a -F --color=always --icons --no-permissions --no-user --no-time";
      nano = "micro";
      nrbs = "sudo nixos-rebuild switch --flake ~/nixConfig";
      nfu = "nix flake update --flake ~/nixConfig";
      udrbsd = "nix flake update --flake ~/nixConfig && sudo nixos-rebuild switch --flake ~/nixConfig && sudo shutdown now";
      grb = "sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old";
      newProj = "nix flake init -t github:mochienya/nix-dev-template";
    };
    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        src = autopair;
      }
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.whitelist = {
      prefix = [ "~/proj/" ];
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Mochie Iosevka";
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
