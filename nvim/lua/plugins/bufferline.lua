return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.custom_filter = function(buf)
        return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified
      end
    end,
  },
}
