-- Home is the shared default; local desk settings can override it below.
require("hypr.monitor_profiles.home")

-- This optional file is gitignored. Errors in an existing override stay visible.
local override = os.getenv("HOME") .. "/.config/hypr/monitors.local.lua"
local file = io.open(override, "r")
if file then
	file:close()
	dofile(override)
end
