-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = 1.6

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

local secondary = "HDMI-A-2"
local main = "HDMI-A-1"

-- Portrait secondary monitor with position at origin (left)
hl.monitor({ output = secondary, position = "0x0", transform = 1 })

-- Distribute workspaces across monitors
for workspace = 1, 10 do
	local monitor = workspace <= 5 and secondary or main
	hl.workspace_rule({
		workspace = tostring(workspace),
		monitor = monitor,
		default = workspace == 1 or workspace == 6,
	})
end
