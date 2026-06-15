return {
	"folke/snacks.nvim",
	opts = {
		picker = {
			win = {
				input = {
					keys = {
						["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
						["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
					},
				},
				list = {
					keys = {
						["<c-d>"] = "preview_scroll_down",
						["<c-u>"] = "preview_scroll_up",
					},
				},
			},
		},
		scroll = {
			enabled = false, -- Disable scrolling animations
		},
	},
}
