args@{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    defaultProfiles = [ "high-quality" ];
    config = {
      input-default-bindings = false;
      input-builtin-bindings = false;

      sub-font = "Nunito";
      sub-outline-color = "0.0/0.3";
      sub-border-style = "opaque-box";
      sub-outline-size = -2;
      sub-filter-regex-append = "opensubtitles\\.org";
      sub-auto = "all";
      slang = "en";

      ytdl-format = "bestvideo+bestaudio/best";
      ytdl-raw-options = "ignore-config=,sub-lang=en,write-sub=,write-auto-sub=";

      demuxer-max-bytes = "1GiB";

      vo = "gpu-next";
      gpu-api = "vulkan";
    };
    bindings = {
      "]" = "add speed 0.25";
      "[" = "add speed -0.25";
      "=" = "set speed 1";
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
      m = "cycle mute";
      j = "add chapter -1";
      l = "add chapter 1";
      y = "script-binding seek_end";
      "`" = "script-binding commands/open";
      k = "script-binding stats/display-stats-toggle";
      "Ctrl+MBTN_LEFT" = "script-binding positioning/drag-to-pan";
      "Ctrl+WHEEL_UP" = "script-binding positioning/cursor-centric-zoom  0.1"; # zoom in towards the cursor
      "Ctrl+WHEEL_DOWN" = "script-binding positioning/cursor-centric-zoom -0.1"; # zoom out towards the cursor
      r = "set video-zoom 0; no-osd set panscan 0; no-osd set video-pan-x 0; no-osd set video-pan-y 0; no-osd set video-align-x 0; no-osd set video-align-y 0";
    };
    scripts =
      with args.pkgs.mpvScripts;
      [
        mpv-osc-tethys
        thumbfast
      ]
      ++ (
        let
          mkScript =
            name: body:
            let
              file = builtins.toFile name body;
            in
            args.pkgs.mpvScripts.buildLua {
              pname = name;
              version = "unstable";
              src = file;
              unpackPhase = ":";
              scriptPath = file;
            };
        in
        [
          (mkScript "auto-sub.lua" ''
            mp.add_hook('on_load', 10, function ()
               mp.set_property('sub-file-paths', 'Subs/' .. mp.get_property('filename/no-ext'))
            end)
          '')
          (mkScript "seek_end.lua" ''
            mp.add_key_binding(nil, "seek_end", function()
              mp.commandv("seek", math.floor(mp.get_property_number("duration")) - 4, "absolute")
            end)
          '')
        ]
      );
  };
}
