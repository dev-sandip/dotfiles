return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha", -- or "mocha", "frappe", "latte"
			transparent_background = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				telescope = {
					enabled = true,
					style = "nvchad",
				},
			},
			highlight_overrides = {
				all = function(colors)
					return {
						Normal = { bg = "NONE" },
						NormalNC = { bg = "NONE" },
						NormalFloat = { bg = "NONE" },
						FloatBorder = { bg = "NONE" },
						VertSplit = { bg = "NONE" },
						SignColumn = { bg = "NONE" },
						StatusLine = { bg = "NONE" },
						WinBar = { bg = "NONE" },
						TabLine = { bg = "NONE" },
						TabLineFill = { bg = "NONE" },
					}
				end,
			},
		},
	},


}
