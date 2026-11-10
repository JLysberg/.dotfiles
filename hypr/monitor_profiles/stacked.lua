-- HDMI Samsung above the USB-C ASUS, both in landscape.
-- USB-C carries DisplayPort here, so Hyprland names it DP-1.
-- Change these to try different UI sizes; higher means larger.
-- Clean scales from 1x through 2x, with resulting logical resolutions.
-- Use fractions directly in Lua rather than rounded decimal approximations.
-- A dash means the scale is not clean for that display.
--
-- Scale   HDMI (3840x2160)   USB-C (2560x1600)
-- 1       3840x2160          2560x1600
-- 16/15   3600x2025          2400x1500
-- 1.2     3200x1800          -
-- 1.25    3072x1728          2048x1280
-- 4/3     2880x1620          1920x1200
-- 1.5     2560x1440          -
-- 1.6     2400x1350          1600x1000
-- 5/3     2304x1296          1536x960
-- 1.875   2048x1152          -
-- 2       1920x1080          1280x800
local upper_scale = 1.25
local lower_scale = 4 / 3

hl.env("GDK_SCALE", "2")
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.6 })

local upper = "HDMI-A-2"
local lower = "DP-1"

-- Recalculate logical positions from the modes and scales, keeping the lower
-- display centered directly beneath the upper one. Positions use whole pixels.
local lower_x = math.floor((3840 / upper_scale - 2560 / lower_scale) / 2 + 0.5)
local lower_y = math.floor(2160 / upper_scale + 0.5)
local lower_position = string.format("%dx%d", lower_x, lower_y)

hl.monitor({ output = upper, mode = "3840x2160@60", position = "0x0", scale = upper_scale, transform = 0 })
hl.monitor({ output = lower, mode = "2560x1600@59.97", position = lower_position, scale = lower_scale, transform = 0 })

for workspace = 1, 10 do
	hl.workspace_rule({
		workspace = tostring(workspace),
		monitor = workspace <= 5 and upper or lower,
		default = workspace == 1 or workspace == 6,
	})
end
