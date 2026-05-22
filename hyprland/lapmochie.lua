hl.monitor {
	output = "eDP-1";
	mode = "highres";
	position = "0x0";
	scale = 1.33;
}

hl.config {
  ["input.touchpad"] = {
    disable_while_typing = false;
    scroll_factor = .5;
    drag_lock = 2;
  };
  -- basically just `f"workspace_swipe_{key}` for every key in the table
  gestures = (function(workspace_swipe_values)
    local result = {}
    for k, v in pairs(workspace_swipe_values) do
      result["workspace_swipe_" .. k] = v
    end
    return result
  end) {
      invert = false;
      forever = true;
      distance = 150;
      direction_lock = false;
      create_new = false;
    };
}

hl.gesture {
  fingers = 2;
  direction = "pinch";
  mods = "SUPER";
  action = "cursor_zoom";
  mode = "live";
  zoom_level = 1;
}

hl.gesture { fingers = 4; direction = "down"; action = "fullscreen"; }
