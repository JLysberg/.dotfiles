-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- yank
map("n", "<leader>fy", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end, { desc = "Yank file path" })
map("n", "<leader>fY", function()
  vim.fn.setreg("+", string.format("%s:%d", vim.fn.expand("%"), vim.fn.line(".")))
end, { desc = "Yank file name and line to clipboard" })

-- window
map("n", "<C-Left>", "<C-w>h", { desc = "Switch to left window" })
map("n", "<C-Right>", "<C-w>l", { desc = "Switch to right window" })
map("n", "<C-Down>", "<C-w>j", { desc = "Switch to window below" })
map("n", "<C-Up>", "<C-w>k", { desc = "Switch to window above" })
map("n", "=", "<cmd>vertical resize +5<cr>", { desc = "Increase window size vertically" })
map("n", "-", "<cmd>vertical resize -5<cr>", { desc = "Decrease window size vertically" })
map("n", "+", "<cmd>horizontal resize +2<cr>", { desc = "Increase window size horizontally" })
map("n", "_", "<cmd>horizontal resize -2<cr>", { desc = "Decrease window size horizontally" })
