{
  description = "mochie nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    plasma-manager.url = "github:nix-community/plasma-manager";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      pkgs = nixpkgs.legacyPackages.${system};
      homeConfig = host: {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs host; };
        users.mochie = import ./home.nix;
      };
    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;
      nixosConfigurations.mochiebox = nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
          host = "mochiebox";
          inherit inputs;
          master = inputs.master.legacyPackages.${system};
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
          master = inputs.master.legacyPackages.${system};
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
      packages.${system}.nyavim =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          # no idea if this is necessary but i didn't want to find out
          modules = (
            map (f: f { inherit pkgs; }) [
              (import ./homeManager/cli/neovim)
            ]
          );
        }).neovim.overrideAttrs
          (
            final: old: {
              meta = {
                name = "nyavim";
                homepage = "https://github.com/mochienya/nixConfig/tree/main/homeManager/cli/neovim";
                description = "mochie's neovim config!! :3";
              };
            }
          );
      apps.${system}.nyavim = {
        type = "app";
        program = "${self.packages.${system}.nyavim}/bin/nvim";
        meta.description = self.packages.${system}.nyavim.meta.description;
      };
    };
}
