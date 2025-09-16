extras@{ pkgs, ... }:
{
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
          command nix shell --impure $pkgs
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
}
