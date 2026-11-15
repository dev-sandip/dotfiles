return {
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },

  -- Colorscheme
  {
    "wtfox/jellybeans.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("jellybeans").setup({
        flat_ui = false,
        on_colors = function(colors)
          colors.background = "#1c1c1c"
        end,
      })
      vim.cmd.colorscheme("jellybeans")
    end,
  },

  -- Scrollbar
  {
    "petertriho/nvim-scrollbar",
    branch = "refactor/v2", -- drop once v2 lands on main (2026-11-16)
    event = "VeryLazy",
    opts = {
      scrollbar = {
        autohide = true,
        track = { highlight = { bg = "#262626" } },
        thumb = { highlight = { bg = "#6c6c6c" }, blend = 0 },
      },
      marks = {
        Error = { text = { "█" }, highlight = { fg = "#ea6962" } },
        Warn = { text = { "█" }, highlight = { fg = "#d8a657" } },
        Info = { text = { "█" }, highlight = { fg = "#7daea3" } },
        Hint = { text = { "█" }, highlight = { fg = "#a9b665" } },
        Misc = { text = { "█" }, highlight = { fg = "#d3869b" } },
      },
    },
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
      },
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      -- stylua: ignore
      local colors = {
        insert_mode_bg   = '#4a90e2',
        visual_mode_bg   = '#f5d142',
        inactive_bg      = '#080808',
        fg               = '#c6c6c6',
        replace_mode_bg  = '#e74c3c',
        normal_mode_bg   = '#2ecc71',
        secondary_bg     = '#303030',
      }

      local bubbles_theme = {
        normal = {
          a = { fg = colors.inactive_bg, bg = colors.normal_mode_bg },
          b = { fg = colors.fg, bg = colors.secondary_bg },
          c = { fg = colors.fg },
        },

        insert = { a = { fg = colors.inactive_bg, bg = colors.insert_mode_bg } },
        visual = { a = { fg = colors.inactive_bg, bg = colors.visual_mode_bg } },
        replace = { a = { fg = colors.inactive_bg, bg = colors.replace_mode_bg } },

        inactive = {
          a = { fg = colors.fg, bg = colors.inactive_bg },
          b = { fg = colors.fg, bg = colors.inactive_bg },
          c = { fg = colors.fg },
        },
      }

      local function macro_recording()
        local reg = vim.fn.reg_recording()
        if reg ~= "" then
          return "recording @" .. reg
        end
        return ""
      end

      require("lualine").setup({
        options = {
          theme = bubbles_theme,
          component_separators = "",
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
          lualine_b = { "filename", "branch", "diff" },
          lualine_c = {
            {
              function()
                local gitsigns = vim.b.gitsigns_blame_line
                if gitsigns then
                  return gitsigns
                end
                return ""
              end,
              icon = "",
            },
            "%=",
          },
          lualine_x = {
            { macro_recording },
            "diagnostics",
          },
          lualine_y = { "filetype", "searchcount" },
          lualine_z = {
            { "location", separator = { right = "" }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = { "filename" },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "location" },
        },
        tabline = {},
        extensions = {},
      })
    end,
  },

  -- Breadcrumbs / winbar symbol picker
  {
    "Bekaboo/dropbar.nvim",
    -- needed for fuzzy-finder support in the symbol picker
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    config = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    end,
  },

  -- Tailwind-aware color highlighting
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- "*" keeps cheap hex/rgb coloring in every filetype (e.g. this config),
      -- while the expensive tailwind matching is enabled only where it's used.
      filetypes = {
        "*",
        css = { tailwind = true },
        scss = { tailwind = true },
        sass = { tailwind = true },
        less = { tailwind = true },
        html = { tailwind = true },
        javascript = { tailwind = true },
        javascriptreact = { tailwind = true },
        typescript = { tailwind = true },
        typescriptreact = { tailwind = true },
        vue = { tailwind = true },
        svelte = { tailwind = true },
      },
      user_default_options = {
        tailwind = false,
      },
    },
  },
}
