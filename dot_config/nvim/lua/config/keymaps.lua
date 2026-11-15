-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- =====================
-- Shell
-- =====================
-- Execute shell command silently
vim.keymap.set("n", "<leader>xs", function()
  local cmd = vim.fn.input("Command: ")
  if cmd ~= "" then
    vim.fn.system(cmd)
  end
end, { desc = "Execute shell command" })

-- =====================
-- Buffer/Tab Navigation
-- =====================
vim.keymap.set("n", "<leader>bp", ":BufferLineMovePrev<CR>", { desc = "Move buffer left" })
vim.keymap.set("n", "<leader>bn", ":BufferLineMoveNext<CR>", { desc = "Move buffer right" })

-- =====================
-- Terminal
-- =====================
-- Open a terminal in the project root (git root if available, else cwd)
vim.keymap.set("n", "<leader>ft", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  local target_dir = (vim.v.shell_error == 0 and git_root ~= "") and git_root or vim.fn.getcwd()
  vim.cmd("terminal")
  vim.cmd("startinsert")
  vim.fn.chansend(vim.b.terminal_job_id, "cd " .. vim.fn.shellescape(target_dir) .. "\n")
end, { desc = "Terminal (project root)" })
vim.keymap.set("n", "<leader>fT", ":terminal<CR>", { desc = "Terminal (current buffer)" })

-- Exit terminal mode with Escape
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- =====================
-- Path Yanking
-- =====================
local function relative_path()
  local abs = vim.fn.expand("%:p")
  local cwd = vim.g.launch_cwd or vim.fn.getcwd()
  if abs:sub(1, #cwd) == cwd then
    return abs:sub(#cwd + 1)
  end
  return abs
end

-- Copy buffer path
vim.keymap.set("n", "<leader>yp", function()
  local path = relative_path()
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy path" })

vim.keymap.set("v", "<leader>yp", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
  local path = relative_path()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local text = path .. "#L" .. start_line .. "-L" .. end_line
  vim.fn.setreg("+", text)
  vim.notify("Copied: " .. text)
end, { desc = "Copy path with line range" })
-- dev-sandip's custom commands
--=====================
-- Editing
--=====================
-- Delete line without cutting (black hole register)
vim.keymap.set("n", "dd", '"_dd', { desc = "Delete line without cutting" })

-- Cut line to system clipboard using _dd
vim.keymap.set("n", "_dd", "dd", { desc = "Cut whole line" })
