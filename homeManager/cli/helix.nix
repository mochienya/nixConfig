{ pkgs, ... }:

{
  home.packages = [ pkgs.helix ];
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "tokyonight";
      editor = {
        middle-click-paste = false;
        shell = [ "fish" ];
        line-number = "relative";
        bufferline = "multiple";
        trim-final-newlines = true;
        trim-trailing-whitespace = true;
        auto-save.focus-lost = true;
        clipboard-provider.custom = {
          yank = {
            command = "wl-copy";
            args = [ ];
          };
          paste = {
            command = "wl-paste";
            args = [ ];
          };
        };
        cursor-shape.insert = "bar";
      };
    };
  };
}
