hl.bind("SUPER + Q", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + C", hl.dsp.window.kill())
hl.bind("SUPER + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin"))
hl.bind("SUPER + V", hl.dsp.window.float())
hl.bind("SUPER + F", hl.dsp.window.fullscreen(0))
hl.bind("SUPER + R", hl.dsp.exec_cmd("hyprlauncher"))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("grim -t ppm - | satty --filename - --fullscreen -o - | wl-copy -t image/png"))

hl.bind("SUPER + left", hl.dsp.focus { direction = "l"; })
hl.bind("SUPER + right", hl.dsp.focus { direction = "r"; })
hl.bind("SUPER + up", hl.dsp.focus { direction = "u"; })
hl.bind("SUPER + down", hl.dsp.focus { direction = "d"; })

for i = 1, 9 do
  hl.bind("SUPER + " .. i, hl.dsp.focus { workspace = "r~" .. i; on_current_monitor = true; })
  hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move { workspace = "r~" .. i; })
end

hl.bind("SUPER + mouse_down", hl.dsp.focus { workspace = "e+1"; })
hl.bind("SUPER + mouse_up", hl.dsp.focus { workspace = "e-1"; })

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true; })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true; })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", { repeating = true; locked = true; })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", { repeating = true; locked = true; })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { repeating = true; locked = true; })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", { repeating = true; locked = true; })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd "brightnessctl -e4 -n2 set 5%+", { repeating = true; locked = true; })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd "brightnessctl -e4 -n2 set 5%-", { repeating = true; locked = true; })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd "playerctl next", { locked = true; })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd "playerctl play-pause", { locked = true; })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd "playerctl play-pause", { locked = true; })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd "playerctl previous", { locked = true; })
