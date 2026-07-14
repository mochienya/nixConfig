{
  description = "mochie nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    yazi.url = "github:sxyazi/yazi";
    # niri still doesn't support enough features for me to use it and i don't feel like learning freedesktop nonsense
    # sorry sweaty...
    hyprland.url = "github:hyprwm/Hyprland";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = rec {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable = nixpkgs;
      };
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://yazi.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    extra-trusted-public-keys = [
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  outputs =
    inputs@{ nixpkgs, ... }:

    let
      system = "x86_64-linux";
      pkgsConfig = {
        config = {
          allowUnfree = true;
        };
        overlays = with inputs; [
          emacs-overlay.overlays.default
          hyprland.overlays.hyprland-packages
          hyprland.overlays.hyprland-extras
        ];
      };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs [ "lapmochie" "mochiebox" ] (
        host:
        nixpkgs.lib.nixosSystem rec {
          specialArgs = {
            inherit host inputs;
            master = import inputs.master (pkgsConfig // { localSystem = system; });
          };
          modules = [
            ./hosts/${host}/hardware-configuration.nix
            ./configuration.nix
            ./modules/services-and-envvars.nix
            ./modules/gaming.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.hyprland.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = specialArgs;
                useUserPackages = true;
                useGlobalPkgs = true;
                backupFileExtension = "bak";
                overwriteBackup = true;
                users.mochie = import ./home.nix;
              };
              nixpkgs = pkgsConfig;
            }
          ];
        }
      );
    };
}
