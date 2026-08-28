local omarchy_theme =
    vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

if vim.fn.filereadable(omarchy_theme) == 1 then
  local ok, theme = pcall(dofile, omarchy_theme)

  if ok and type(theme) == "table" then
    return theme
  end
end

-- Portable fallback for WSL and other non-Omarchy systems.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
