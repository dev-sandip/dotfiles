return {
  -- venv-selector with pyenv support
  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      pyenv_path = vim.fn.expand("~/.pyenv/versions"),
    },
  },

  -- LSP servers
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        marksman = false,
        pyright = {},
        tailwindcss = {},
        ruff = {
          init_options = {
            settings = {
              path = { "ruff" },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
    },
    setup = {
      gopls = function(_, _opts)
        -- workaround for gopls not supporting semanticTokensProvider
        -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
        LazyVim.lsp.on_attach(function(client, _)
          if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            if semantic then
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end
        end, "gopls")
      end,
    },
  },

  -- Treesitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "2bd9b9b4f12eed175fba35ca2db8e8584546a4ec",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "go",
        "gomod",
        "gowork",
        "gosum",
      },
    },
  },

  -- Configure linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },

  -- Configure formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = {
          -- To fix auto-fixable lint errors.
          "ruff_fix",
          -- To run the Ruff formatter.
          "ruff_format",
        },
        -- TypeScript/JavaScript formatting handled by LazyVim extras
      },
      formatters = {
        ruff_fix = {
          args = { "check", "--fix", "--unfixable=F401", "--force-exclude", "--exit-zero", "-" },
        },
        prettier = {
          cwd = require("conform.util").root_file({
            ".prettierignore",
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.js",
          }),
        },
      },
    },
  },

  -- Mason tool installer
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "ruff",
        "eslint_d",
        "prettier",
      },
    },
  },
}
