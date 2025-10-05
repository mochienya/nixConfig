{ ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    # fuck you i hate `let in` for literally everything
    settings = rec {
      theme = "material_deep_ocean";
      editor = {
        middle-click-paste = false;
        line-number = "relative";
        bufferline = "multiple";
        shell = [
          "fish"
          "-c"
        ];
        continue-comments = false;
        completion-timeout = 5;
        auto-format = false;
        cursor-shape.insert = "bar";
        auto-save = {
          focus-lost = true;
          after-delay.enable = true;
          after-delay.timeout = 500;
        };
      };
      keys.normal = {
        # most of the time i don't care about what i'm deleting
        # i might delete something while moving around even if i DO care
        # and using registers is inconvenient
        "d" = "delete_selection_noyank";
        "A-d" = "delete_selection";
        "c" = "change_selection_noyank";
        "A-c" = "change_selection";
        "D" = [
          "move_char_left"
          "delete_selection_noyank"
        ];
        "A-j" = "@x\"m<A-d>j\"mP;";
        "A-k" = "@x\"m<A-d>k\"mP;";
        "C-I" = ":format";
        "." = "repeat_last_motion";
        "H" = "goto_first_nonwhitespace";
        "L" = "goto_line_end";
        "C-h" = "goto_previous_buffer";
        "C-l" = "goto_next_buffer";
        "i" = [
          "collapse_selection"
          "insert_mode"
        ];
        "a" = [
          "collapse_selection"
          "append_mode"
        ];
        "esc" = [
          "keep_primary_selection"
          "collapse_selection"
        ];
      };
      # i wanted to use lazygit too but the escape key doesn't work in the offical docs' recipe
      # and [the issue](https://github.com/helix-editor/helix/issues/13818) was marked as not planned... (neogit is calling)
      keys.normal.space = {
        e = [
          ":sh rm -f /tmp/unique-file-h21a434"
          ":insert-output yazi '%{buffer_name}' --chooser-file=/tmp/unique-file-h21a434"
          ":insert-output echo \"x1b[?1049h\" > /dev/tty"
          ":open %sh{cat /tmp/unique-file-h21a434}"
          ":redraw"
          ":set mouse false"
          ":set mouse true"
        ];
      };
      keys.insert = {
        "C-c" = "toggle_line_comments";
      };
      # idk if it actually follows normal mode config when changed but i don't feel like finding out rn (ever)
      keys.select = keys.normal // {
        "esc" = "normal_mode";
      };
    };
  };
}
