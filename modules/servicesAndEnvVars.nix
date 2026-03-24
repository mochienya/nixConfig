{ lib, pkgs, host, ... }:
{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  programs.ssh.startAgent = true;
  programs.ssh.enableAskPassword = true;

  programs.fish.enable = true;

  # WHY does home manager not have direnvcExtra?? i hate you
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    loadInNixShell = true;
    silent = true;
    settings.whitelist.prefix = [ "~/proj/" ];
    direnvrcExtra = ''
      : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
          )}"
      }
    '';
  };

  # fixes unicode support
  home-manager.users.mochie.home.file.".XCompose".source = "${pkgs.keyd}/share/keyd/keyd.compose";
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "escape";
          escape = "capslock";
          "102nd" = "oneshot(norwegian)";
        };
        norwegian = {
          a = "å";
          e = "æ";
          o = "ø";
        };
        "norwegian+shift" = {
          a = "Å";
          e = "Æ";
          o = "Ø";
        };
        "meta+shift".f23 = lib.optionalString (host == "lapmochie") "macro(You're space absolutely space correct!)";
      };
    };
  };
}
