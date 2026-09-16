package.path = package.path .. ";/home/mochie/.config/hypr-host/?.lua"
require "host"
require "appearance"
require "binds"
local utils <const> = require "utils"

utils.env_table {
  XDG_CURRENT_DESKTOP = "Hyprland";
  XDG_SESSION_TYPE = "wayland";
  XDG_SESSION_DESKTOP = "Hyprland";
  QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  QT_QPA_PLATFORMTHEME = "qt5ct";
}

hl.on("hyprland.start", function ()
  hl.exec_cmd "dms run"
  hl.exec_cmd "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland"
  hl.exec_cmd "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
end)

hl.config {
  misc = {
    force_default_wallpaper = 0;
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    -- doing git operations sometimes causes the entire thing to break and need a reload manually anyway
    -- also config yelling at me if i stop writing a line partway through
    disable_autoreload = true;
    font_family = "Nunito";
    middle_click_paste = false;
  };

  input = {
    kb_layout = "us";
    repeat_delay = 400;

    follow_mouse = 2;
    accel_profile = "flat";
    ["touchpad.natural_scroll"] = false;
  };
  ["xwayland.force_zero_scaling"] = true;
}

-- my mouse gets a different name when using wireless dongle vs wired
;(function()
  ---@type HL.DeviceSpec
  local base <const> = {
    name = "";
    sensitivity = -.8;
  }
  hl.device(utils.merge_tables(base, { name = "logitech-usb-receiver" }))
  hl.device(utils.merge_tables(base, { name = "logitech-pro-x-2-dex"  }))
  hl.device(utils.merge_tables(base, { name = "logitech-pro-x-2-dex-1"  }))
end)()

hl.monitor {
  output = "";
  mode = "preferred";
  position = "auto";
  scale = "auto";
}

hl.window_rule {
    name = "suppress-maximize-events";
    match = { class = ".*" };
    suppress_event = "maximize";
}
