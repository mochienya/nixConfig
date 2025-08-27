{
  description = "mochie nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    plasma-manager.url = "github:nix-community/plasma-manager";

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      homeConfig = host: {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
          inherit host;
        };
        users.mochie = import ./home.nix;
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations.mochiebox = nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
          host = "mochiebox";
          inherit inputs;
        };
        modules = [
          ./configuration.nix
          ./hosts/mochiebox/hardware-configuration.nix
          ./modules/servicesAndEnvVars.nix
          ./modules/gaming.nix
          inputs.nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          { home-manager = homeConfig specialArgs.host; }
        ];
      };
      nixosConfigurations.lapmochie = nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
          host = "lapmochie";
          inherit inputs;
        };
        modules = [
          ./configuration.nix
          ./modules/servicesAndEnvVars.nix
          ./modules/gaming.nix
          ./hosts/lapmochie/hardware-configuration.nix
          inputs.nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          { home-manager = homeConfig specialArgs.host; }
        ];
      };
    };
}
