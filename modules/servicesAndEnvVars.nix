{ ... }:
{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };

  programs.ssh.startAgent = true;

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
}
