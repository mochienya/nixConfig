{
  description = "mochie nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    plasma-manager.url = "github:nix-community/plasma-manager";
    yazi.url = "github:sxyazi/yazi";

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
    # caches here are for packages only my system uses, anything useful for other flakes should go in the configuration.nix one
    extra-substituters = [ "https://yazi.cachix.org" ];
    extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
  };

  outputs =
    inputs@{ nixpkgs, ... }:

    let
      system = "x86_64-linux";
      pkgsConfig = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          inputs.emacs-overlay.overlays.default
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
            ./modules/servicesAndEnvVars.nix
            ./modules/gaming.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak
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
