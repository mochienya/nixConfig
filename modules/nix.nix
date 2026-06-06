args@{ pkgs, ... }:

{
  nix.settings =
    let
      flakeConfAttrs = (import ../flake.nix).nixConfig;
    in
    {
      auto-optimise-store = true;
      trusted-users = [ "mochie" ];
      substituters = flakeConfAttrs.extra-substituters;
      trusted-public-keys = flakeConfAttrs.extra-trusted-public-keys;

      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      # unlimited
      http-connections = 0;
      max-jobs = "auto";
      max-substitution-jobs = 128;
      download-buffer-size = 524288000;

      warn-dirty = false;
    };

  nix.registry.master = {
    from = {
      type = "indirect";
      id = "master";
    };
    to = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "master";
    };
  };

}
