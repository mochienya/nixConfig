{ ... }:

{
  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [ "mochie" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

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

  nix.gc = {
    automatic = true;
    dates = "Mon,Wed,Fri,Sun *-*-* 00:00:00";
    options = "--delete-old";
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
