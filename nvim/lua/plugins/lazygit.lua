return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      require("config.lazygit").setup()

      local open_file = vim.fn.stdpath("config") .. "/bin/lazygit-open-file"

      opts.lazygit = opts.lazygit or {}
      opts.lazygit.config = opts.lazygit.config or {}
      opts.lazygit.config.os = vim.tbl_deep_extend("force", opts.lazygit.config.os or {}, {
        edit = open_file .. " {{filename}}",
        editAtLine = open_file .. " {{filename}} {{line}}",
      })
    end,
  },
}
