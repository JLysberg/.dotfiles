-- Home: two identical Samsung LS27A800U 3840x2160 monitors over HDMI.
-- Portrait on the left (1–5); landscape directly ahead on the right (6–10).
-- Top edges align, and the landscape monitor touches the portrait's right edge.
-- Change these to try different UI sizes; higher means larger.
-- Clean scales from 1x through 2x, with resulting logical resolutions.
-- Use fractions directly in Lua rather than rounded decimal approximations.
--
-- Scale   Left / portrait   Right / landscape
-- 1       2160x3840         3840x2160
-- 16/15   2025x3600         3600x2025
-- 1.2     1800x3200         3200x1800
-- 1.25    1728x3072         3072x1728
-- 4/3     1620x2880         2880x1620
-- 1.5     1440x2560         2560x1440
-- 1.6     1350x2400         2400x1350
-- 5/3     1296x2304         2304x1296
-- 1.875   1152x2048         2048x1152
-- 2       1080x1920         1920x1080
local left_scale = 1.25
local right_scale = 1.25

hl.env("GDK_SCALE", "2")
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.6 })

local left = "HDMI-A-2"
local right = "HDMI-A-1"

-- Rotation makes the left monitor 2160 pixels wide before scaling.
local right_x = math.floor(2160 / left_scale + 0.5)
local right_position = string.format("%dx0", right_x)

hl.monitor({ output = left, mode = "3840x2160@60", position = "0x0", scale = left_scale, transform = 1 })
hl.monitor({ output = right, mode = "3840x2160@60", position = right_position, scale = right_scale, transform = 0 })

for workspace = 1, 10 do
	hl.workspace_rule({
		workspace = tostring(workspace),
		monitor = workspace <= 5 and left or right,
		default = workspace == 1 or workspace == 6,
	})
end
