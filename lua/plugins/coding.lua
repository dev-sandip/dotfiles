return {
	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},

	-- Go forward/backward with square brackets
	{
		"echasnovski/mini.bracketed",
		event = "BufReadPost",
		config = function()
			local bracketed = require("mini.bracketed")
			bracketed.setup({
				file = { suffix = "" },
				window = { suffix = "" },
				quickfix = { suffix = "" },
				yank = { suffix = "" },
				treesitter = { suffix = "n" },
			})
		end,
	},

	-- Better increase/decrease
	{
		"monaqa/dial.nvim",
		-- stylua: ignore
		keys = {
			{ "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
			{ "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
		},
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.constant.alias.bool,
					augend.semver.alias.semver,
					augend.constant.new({ elements = { "let", "const" } }),
				},
			})
		end,
	},

	-- copilot
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	opts = {
	-- 		suggestion = {
	-- 			auto_trigger = true,
	-- 			keymap = {
	-- 				accept = "<C-l>",
	-- 				accept_word = "<M-l>",
	-- 				accept_line = "<M-S-l>",
	-- 				next = "<M-]>",
	-- 				prev = "<M-[>",
	-- 				dismiss = "<C-]>",
	-- 			},
	-- 		},
	-- 		filetypes = {
	-- 			markdown = true,
	-- 			help = true,
	-- 		},
	-- 	},
	-- },

	-- discord rich presence
	{
		"vyfor/cord.nvim",
		build = ":Cord update",
		event = "VeryLazy",
		opts = function()
			return {
				usercmds = true,
				log_level = "error",
				timer = {
					interval = 1500,
					reset_on_idle = false,
					reset_on_change = false,
				},
				editor = {
					image = nil,
					client = "neovim",
					tooltip = "Sandy's Neovim",
				},
				display = {
					theme = 'default',
					flavor = 'accent',
					show_time = true,
					show_repository = true,
					show_cursor_position = true,
					swap_fields = false,
					workspace_blacklist = {},
				},
				lsp = {
					show_problem_count = false,
					severity = 1,
					scope = "workspace",
				},
				idle = {
					enable = true,
					show_status = true,
					timeout = 300000,
					disable_on_focus = true,
					icon = require('cord.api.icon').get('idle', 'default', 'accent'),
					tooltip = "💤",
					details = function(opts)
						return string.format('Taking a break from %s', opts.workspace)
					end
				},
				buttons = {
					{
						label = function(opts)
							return opts.repo_url and 'View Repository' or 'My Website'
						end,
						url = function(opts)
							return opts.repo_url or 'https://sandipsapkota.com'
						end
					}
				}
			}
		end,
	},
}
