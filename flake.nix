{
  description = "mochie nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    mcp-nixos.url = "github:utensils/mcp-nixos";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations.mochiebox = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          nixpkgs = pkgs;
          inherit inputs;
        };
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./modules/servicesAndEnvVars.nix
          ./modules/gaming.nix
          inputs.nix-flatpak.nixosModules.nix-flatpak

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
                inherit pkgs;
              };

              users.mochie = import ./home.nix;
            };
          }
        ];
      };
      homeConfigurations."mochie@mochiebox" = inputs.home-manager.lib.homeManagerConfiguration {
        # nixd forced me to put this here i think it's dumb
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs;
          inherit system;
        };
        modules = [
          ./home.nix
        ];
      };
    };
}
