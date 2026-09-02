-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

--------------------------------------------------

hl.unbind("SUPER + ALT + RETURN")
o.bind(
	"SUPER + ALT + RETURN",
	"Tmux",
	'uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "tmux"'
)
o.bind("SUPER + CTRL + ALT + RETURN", "Tmux (auto-attach)", { omarchy = "terminal-tmux" })

hl.unbind("SUPER + CTRL + RETURN")
o.bind(
	"SUPER + CTRL + RETURN",
	"Tmux project",
	{ tui = (os.getenv("HOME") or "") .. "/.config/tmux/project" }
)

hl.unbind("SUPER + SHIFT + M")
hl.unbind("SUPER + SHIFT + ALT + M")
o.bind("SUPER + SHIFT + M", "Music TUI", { tui = "cliamp", focus = true })
o.bind("SUPER + SHIFT + ALT + M", "Music Search", "~/.config/hypr/scripts/cliamp-spotify-search")

hl.unbind("SUPER + SHIFT + D")
o.bind(
	"SUPER + SHIFT + D",
	"Discord",
	{ webapp = "https://discord.com/channels/876458732777766922/1010946629521637387", focus = true }
)

o.bind("SUPER + SHIFT + T", "Monkeytype", { webapp = "https://monkeytype.com", focus = true })

hl.unbind("SUPER + L")
o.bind("SUPER + L", "Toggle workspace layout", "~/.config/hypr/scripts/workspace-layout-toggle")

hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")
