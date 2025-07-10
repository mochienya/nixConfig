{ pkgs, ... }:

{
  programs.steam.enable = true;

  services.flatpak = {
    enable = true;
    packages = [{ appId = "org.vinegarhq.Sober"; origin = "flathub"; }];
    update.onActivation = true;
    uninstallUnmanaged = true;
  };
  # autoclicker that supports wayland from github
  environment.systemPackages = [(pkgs.rustPlatform.buildRustPackage rec {
    pname = "theclicker";
    version = "0.2.3";
    cargoHash = "sha256-JL/X2s/SnmK88btz/MmB6t8nKqUXks07+tWXc4trfLM=";
    # getting these hashes was by far the worst part of doing this
    src = pkgs.fetchFromGitHub {
      owner = "konkitoman";
      repo = "autoclicker";
      rev = version;
      hash = "sha256-Q5Uwl2SWdat/cHRPf4GVQihn1NwlFKbkpWRFnScnvw0=";
    };
  })];
}
