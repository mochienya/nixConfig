{ pkgs, ... }:

{
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
        cursor-shape.insert = "bar";
        auto-save.focus-lost = true;
      };
    };
  };
}
