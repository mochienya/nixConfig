{ pkgs, ... }:
let
  auto-sub =
    let
      file = builtins.toFile "auto-sub.lua" ''
        mp.add_hook('on_load', 10, function ()
           mp.set_property('sub-file-paths', 'Subs/' .. mp.get_property('filename/no-ext'))
        end)
      '';
    in
    pkgs.mpvScripts.buildLua {
      pname = "auto-sub";
      version = "1.0.0";
      src = file;
      unpackPhase = ":";
      scriptPath = file;
    };
  seek-end =
    let
      file = builtins.toFile "seek-end.lua" ''
        function seek_end()
          mp.set_property("time-pos", mp.get_property_native("duration") - 5)
        end
        mp.add_key_binding("y", "seek_end", seek_end)
      '';
    in
    pkgs.mpvScripts.buildLua {
      pname = "seek-end";
      version = "1.0.0";
      src = file;
      unpackPhase = ":";
      scriptPath = file;
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
      y = "script-binding seek-end";
      "`" = "script-binding console/enable";
    };
    scripts =
      with pkgs.mpvScripts;
      [
        mpv-osc-tethys
        thumbfast
      ]
      ++ [
        seek-end
        auto-sub
      ];
  };
}
