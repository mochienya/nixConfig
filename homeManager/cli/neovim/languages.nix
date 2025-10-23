{ pkgs, ... }:
{
  enableFormat = true;
  enableTreesitter = true;
  enableExtraDiagnostics = true;
  nix = {
    enable = true;
    format.type = "nixfmt";
    lsp = {
      server = "nixd";
      options.nixd = {
        nixpkgs.expr = ''import (builtins.getFlake "/home/mochie/nixConfig").inputs.nixpkgs { config.allowUnfree = true; }'';
      };
    };
  };
  ts = {
    enable = true;
    extensions.ts-error-translator.enable = true;
    format.package = pkgs.biome.overrideAttrs (
      final: old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper ];
        postInstall = ''
          ${old.postInstall or ""}
          wrapProgram $out/bin/${final.pname} --append-flags "--indent-style=tab --line-ending=lf --semicolons=as-needed"
        '';
      }
    );
  };
}
