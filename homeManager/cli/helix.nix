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
      keys.normal = {
        # most of the time i don't care about what i'm deleting
        # i might delete something while moving around even if i DO care
        # and using registers is inconvenient
        "d" = "delete_selection_noyank";
        "A-d" = "delete_selection";
        "c" = "change_selection_noyank";
        "A-c" = "change_selection";
        # "A-j" = ["select_register m" "delete_selection" "move_visual_line_down" "paste_after"];
        # "A-k" = ["select_register m" "delete_selection" "move_visual_line_up" "paste_after"];
      };
    };
  };
}
