-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Disable default spell autocmd
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")

-- =====================
-- Auto-save Configuration
-- =====================
-- Auto-save on InsertLeave, FocusLost, and BufLeave.
-- Formatting runs synchronously but with a short, bounded timeout: conform
-- kills the formatter process if it exceeds the timeout, so no formatter job
-- is ever left running in the background. (An earlier async version had no
-- such timeout, so a slow/hung formatter job could linger and block Neovim
-- from exiting on :wqall.)
-- checktime runs first to reload external changes before saving.

-- Save a buffer without triggering LazyVim's synchronous format-on-save.
-- (We handle formatting ourselves below.)
local function save_without_format(buf)
  local prev = vim.b[buf].autoformat
  vim.b[buf].autoformat = false
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("silent! update")
  end)
  vim.b[buf].autoformat = prev
end

-- InsertLeave is intentionally excluded: it fires on every <Esc> and collides
-- with Neovim's pull-diagnostic request (textDocument/diagnostic). The async
-- formatter's edits land on top of that in-flight pull and cancel it, so freshly
-- computed diagnostics get discarded before they render. Saving/formatting only
-- when leaving the buffer or losing focus avoids the storm; a cancelled pull on
-- BufLeave self-heals on the next BufEnter.
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  callback = function(args)
    local buf = args.buf
    if not (vim.bo[buf].modifiable and not vim.bo[buf].readonly) then
      return
    end
    -- Reload file if changed externally (prevents overwriting after branch switch)
    vim.cmd("silent! checktime")
    if not vim.bo[buf].modified then
      return
    end

    -- Format first (bounded by timeout_ms), then save once.
    local ok, conform = pcall(require, "conform")
    if ok then
      conform.format({ bufnr = buf, timeout_ms = 500, lsp_format = "fallback" })
    end

    save_without_format(buf)
  end,
  desc = "Format and save buffer on InsertLeave/FocusLost/BufLeave",
})

-- =====================
-- Window Dimming Configuration
-- =====================
local ACTIVE_WINDOW_DIM_FACTOR = 0.85

local function set_window_highlights()
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })

  if normal_hl.bg then
    local bg = normal_hl.bg
    local r = math.floor(bg / 65536)
    local g = math.floor((bg % 65536) / 256)
    local b = bg % 256

    r = math.floor(r * ACTIVE_WINDOW_DIM_FACTOR)
    g = math.floor(g * ACTIVE_WINDOW_DIM_FACTOR)
    b = math.floor(b * ACTIVE_WINDOW_DIM_FACTOR)

    local dimmed_bg = r * 65536 + g * 256 + b
    vim.api.nvim_set_hl(0, "ActiveWindow", { bg = dimmed_bg })
  else
    vim.api.nvim_set_hl(0, "ActiveWindow", { bg = "#0d0d0d" })
  end

  vim.api.nvim_set_hl(0, "InactiveWindow", { bg = normal_hl.bg })
end

local function set_cursor_highlights()
  -- Idempotent: ColorScheme fires repeatedly, and :append is not deduped,
  -- so guard against stacking duplicate guicursor entries over a session.
  if not vim.o.guicursor:find("a:Cursor/lCursor", 1, true) then
    vim.opt.guicursor:append("a:Cursor/lCursor")
  end
end

-- Apply highlights on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    set_window_highlights()
    set_cursor_highlights()
  end,
  desc = "Reapply window dim and cursor highlights on colorscheme change",
})

-- Set initial highlight groups
set_window_highlights()
set_cursor_highlights()

-- Apply window highlighting on focus change.
-- Only write winhl when it actually changes; setting it unconditionally forces
-- a full-window redraw on every focus event, which causes flicker/churn.
local function set_winhl(value)
  -- Skip diff windows to preserve diff highlighting
  if vim.wo.diff then
    return
  end
  if vim.wo.winhl ~= value then
    vim.wo.winhl = value
  end
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  callback = function()
    set_winhl("Normal:ActiveWindow")
  end,
  desc = "Highlight the active window",
})

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    set_winhl("Normal:InactiveWindow")
  end,
  desc = "Dim the inactive window",
})

-- =====================
-- Terminal Configuration
-- =====================
-- Disable auto-entering terminal mode when navigating to terminal buffers
-- Remove LazyVim's default terminal autocmd that auto-enters insert mode
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_terminal")

-- Configure terminal buffers to have cleaner UI
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
  desc = "Hide line numbers in terminal buffers",
})

-- =====================
-- LSP Configuration
-- =====================
-- Disable Ruff hover in favor of Pyright
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == "ruff" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: Disable hover capability from Ruff",
})
