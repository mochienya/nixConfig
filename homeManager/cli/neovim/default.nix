{ pkgs, ... }:
{
  config.vim = {
    options = {
      exrc = true;
    };
    lsp = {
      enable = true;
      trouble.enable = true;
    };
    languages = import ./languages.nix { inherit pkgs; };
    utility = {
      motion.flash-nvim = {
        enable = true;
        mappings = {
          jump = "m";
          treesitter = "M";
        };
      };
      surround = {
        enable = true;
        useVendoredKeybindings = false;
      };
    };
    autopairs.nvim-autopairs.enable = true;
    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
      setupOpts.completion.documentation.auto_show_delay_ms = 50;
      mappings = {
        close = "<C-c>";
        scrollDocsDown = "<C-d>";
        scrollDocsUp = "<C-u>";
      };
    };
  };
}
