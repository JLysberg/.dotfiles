local M = {}

local ignored_filetypes = {
  "neo-tree",
  "neo-tree-popup",
  "notify",
  "snacks_terminal",
}

local ignored_buftypes = {
  "terminal",
  "quickfix",
  "prompt",
}

local function is_ignored_window(win)
  if not vim.api.nvim_win_is_valid(win) then
    return true
  end

  if vim.api.nvim_win_get_config(win).relative ~= "" then
    return true
  end

  local buf = vim.api.nvim_win_get_buf(win)
  local bo = vim.bo[buf]

  return vim.tbl_contains(ignored_filetypes, bo.filetype) or vim.tbl_contains(ignored_buftypes, bo.buftype)
end

local function editor_windows()
  return vim.tbl_filter(function(win)
    return not is_ignored_window(win)
  end, vim.api.nvim_tabpage_list_wins(0))
end

local function close_lazygit()
  local ok, terminal = pcall(require, "snacks.terminal")

  if not ok then
    return
  end

  for _, term in ipairs(terminal.list()) do
    local buf = term.buf
    local info = buf and vim.api.nvim_buf_is_valid(buf) and vim.b[buf].snacks_terminal
    local cmd = info and info.cmd

    if type(cmd) == "table" and cmd[1] == "lazygit" then
      local channel = vim.bo[buf].channel

      if channel and channel > 0 then
        pcall(vim.api.nvim_chan_send, channel, "q")
      end

      if term.win and vim.api.nvim_win_is_valid(term.win) then
        pcall(vim.api.nvim_win_close, term.win, true)
      end
    end
  end
end

local function pick_window(windows)
  if #windows == 0 then
    return nil
  end

  if #windows == 1 then
    return windows[1]
  end

  local ok, picker = pcall(require, "window-picker")

  if not ok then
    return windows[1]
  end

  return picker.pick_window({
    filter_func = function()
      return windows
    end,
  })
end

function M.open_file(file, line)
  close_lazygit()

  local win = pick_window(editor_windows()) or vim.api.nvim_get_current_win()

  vim.api.nvim_set_current_win(win)
  vim.api.nvim_cmd({ cmd = "edit", args = { file } }, {})

  line = tonumber(line)

  if line and line > 0 then
    local last_line = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_win_set_cursor(0, { math.min(line, last_line), 0 })
  end

  return ""
end

function M.open_file_b64(file_b64, line)
  return M.open_file(vim.base64.decode(file_b64), line)
end

function M.setup()
  _G.LazygitEditFile = function(file_b64, line)
    return require("config.lazygit").open_file_b64(file_b64, line)
  end
end

return M
