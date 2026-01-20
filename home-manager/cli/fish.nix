extras@{ pkgs, ... }:
{
  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    functions = {
      nish.body = ''
        argparse -N1 'm/master' -- $argv; or return 1

        if set -q _flag_master
            set -f pkgs "github:NixOS/nixpkgs/master#"$argv
        else
            set -f pkgs "nixpkgs#"$argv
        end

        set -fx NIXPKGS_ALLOW_UNFREE 1
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
      nrbs = "nh os switch ~/nixConfig -H ${extras.host}";
      nfu = "nix flake update";
      udrbsd = "nh os boot ~/nixConfig -uH ${extras.host} && sudo shutdown now";
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
