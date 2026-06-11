return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      local function buffer_is_modified(buf)
        return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.bo[buf].modified
      end

      opts.options = opts.options or {}
      opts.options.always_show_bufferline = true
      opts.options.custom_filter = function(buf)
        return buffer_is_modified(buf)
      end

    end,
  },
}
