{
  language = [
    {
      name = "nix";
      auto-pairs = {
        "(" = ")";
        "{" = "}";
        "[" = "]";
        "\"" = "\"";
        "=" = ";";
      };
    }
  ];
  language-server = {
    nixd.config.nixd = {
      # mrw nix inside toml inside nix
      nixpkgs.expr = "import (builtins.getFlake \"/home/mochie/nixConfig\").inputs.nixpkgs { config.allowUnfree = true; }";
    };
  };
}
