local ignored_dirs = {
  ".git",
  "node_modules",
  "bower_components",
  "vendor",
  "__pycache__",
  ".pytest_cache",
  "*.pyc",
  ".next",
  ".nuxt",
  "dist",
  "build",
  "out",
  ".cache",
  "coverage",
  "target",
  ".hg",
  ".svn",
}

-- Convert a flat list of ignore patterns into fd's repeated `--exclude <pattern>` args
local function fd_exclude_args(dirs)
  local args = {}
  for _, dir in ipairs(dirs) do
    table.insert(args, "--exclude")
    table.insert(args, dir)
  end
  return args
end

return {


  -- Gitsigns configuration
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
    },
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
          },
          never_show = {},
        },
      },
    },
  },

  -- Fuzzy finder
  {
    "dmtrKovalenko/fff.nvim",
    commit = "1cd8d31da4c1536be11c4dae0ed61d066e05e87f",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      fd_extra_args = fd_exclude_args(ignored_dirs),
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("fff").find_files()
        end,
        desc = "Find files (fff)",
      },
      {
        "<leader>fF",
        function()
          require("fff").find_in_git_root()
        end,
        desc = "Find files in git root (fff)",
      },
      {
        "<leader><space>",
        function()
          require("fff").find_files()
        end,
        desc = "Find files (fff)",
      },
    },
  },

  -- Snacks utilities (picker, terminal, git browse, etc.)
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ff", false }, -- disable default, using fff.nvim instead
    },
    ---@type snacks.Config
    opts = {
      gitbrowse = {
        -- "repo" | "branch" | "file" | "commit" | "permalink"
        what = "permalink",
      },
      animate = { enabled = false },
      picker = {
        sources = {
          grep = {
            exclude = ignored_dirs,
          },
        },
      },
      terminal = {
        win = {
          position = "right",
          width = 0.3,
        },
      },
      scroll = { enabled = false },
    },
  },
}


