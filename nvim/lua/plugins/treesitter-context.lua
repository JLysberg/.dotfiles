return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = function(_, opts)
      opts.max_lines = 0
    end,
  },
}
