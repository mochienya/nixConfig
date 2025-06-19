{ pkgs, ... }:
let
  auto_sub = pkgs.mpvScripts.buildLua {
    pname = "auto_sub";
    src = pkgs.writeTextFile {
      name = "auto_sub.lua";
      text = ''
        mp.add_hook('on_load', 10, function ()
           mp.set_property('sub-file-paths', 'Subs/' .. mp.get_property('filename/no-ext'))
        end)
      '';
    };
  };
  seek_end = pkgs.mpvScripts.buildLua {
    pname = "seek_end";
    src = pkgs.writeTextFile {
      name = "seek_end.lua";
      text = ''
        mp.register_script_message("seek_end", function()
           local duration = mp.get_property_number("duration")
           if duration then
              mp.commandv("seek", duration - 5, "absolute")
           end
        end)
      '';
    };
  };
in
{
  programs.mpv = {
    enable = true;
    config = {
      input-default-bindings = false;
      input-builtin-bindings = false;
      sub-outline-color = "0.0/0.3";
      sub-border-style = "opaque-box";
      sub-outline-size = -2;
      sub-filter-regex-append = "opensubtitles\\.org";
      sub-auto = "all";
      hidpi-window-scale = false;
      hwdec = "auto";
      profile = "high-quality";
      # vo = "gpu-next";
      vulkan-swap-mode = "auto";
      gpu-context = "wayland";
    };
    bindings = {
      "]" = "add speed 0.5";
      "[" = "add speed -0.5";
      SPACE = "cycle pause";
      RIGHT = "seek 5 exact";
      LEFT = "seek -5 exact";
      v = "cycle sub";
      V = "cycle sub down";
      b = "cycle audio";
      B = "cycle audio down";
      f = "cycle fullscreen";
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
      j = "add chapter -1";
      l = "add chapter 1";
      y = "script-binding seek_end";
      "`" = "script-binding console/enable";
    };
    scripts =
      with pkgs.mpvScripts;
      [
        mpv-osc-tethys
        thumbfast
      ]
      ++ [
        seek_end
        auto_sub
      ];
  };
}
