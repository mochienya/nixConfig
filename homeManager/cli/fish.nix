extras@{ pkgs, ... }:
{
  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    functions = {
      nish.body = ''
        argparse -N1 'm/master' -- $argv; or return 1
        set -f branch "nixos-unstable"
        set -q _flag_master; and set -f branch "master"

        set -fx NIXPKGS_ALLOW_UNFREE 1
        set -f pkgs "github:NixOS/nixpkgs/$branch#"$argv
        command nix shell --impure $pkgs
      '';
      mpvfuck.body = ''
        set file (command cat (which mpv))
        set match (string match -r 'mpv"\s+(.+)\s"\$@"' $file)[2]
        set replace (string replace -a -- "--script=" '; load-script ' $match)
        command wl-copy (string sub -s 3 $replace)'';
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
      grb = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
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
