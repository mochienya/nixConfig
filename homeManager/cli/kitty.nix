{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "Mochie Iosevka";
      size = 16;
    };
    settings = {
      confirm_os_window_close = 0;
      wayland_titlebar_color = "background";
      enable_audio_bell = false;
      cursor_shape = "beam";
      tab_bar_edge = "bottom";
      shell = "fish";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      symbol_map = "U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6AA,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F32F,U+F400-U+F4A9,U+F500-U+F8FF,U+F0001-U+F1AF0 Symbols Nerd Font Mono";
    };
    themeFile = "Campbell";
    keybindings = {
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+w" = "close_tab";
      "alt+1" = "goto_tab 1";
      "alt+2" = "goto_tab 2";
      "alt+3" = "goto_tab 3";
      "alt+4" = "goto_tab 4";
      "alt+5" = "goto_tab 5";
      "alt+6" = "goto_tab 6";
      "alt+7" = "goto_tab 7";
      "alt+8" = "goto_tab 8";
      "alt+9" = "goto_tab 9";
    };
  };
  # i know it doesn't really belong here, fuck you
  xdg.desktopEntries.kitty = {
    name = "kitty";
    type = "Application";
    genericName = "Terminal emulator";
    exec = "${pkgs.kitty}/bin/.kitty-wrapped";
    comment = "meow";
    terminal = false; # as in it shouldn't be ran inside a terminal
    categories = [
      "System"
      "TerminalEmulator"
    ];
    startupNotify = true; # it was in the original desktop entry, no clue what it's for
    icon = (
      pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/sodapopcan/kitty-icon/70d0c7bc002fefd16b6d2d9becbc491d08033492/kitty.app.png";
        hash = "sha256-5a56y8qzquZocPyWwadhkF+0fZ04Xaqr1z29QqE78LE=";
      }
    );
  };
}
