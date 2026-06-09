local function terraform_root(bufnr, on_dir)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local root = vim.fs.root(bufnr, { "main.tf", "versions.tf", "providers.tf", ".terraform" })
  on_dir(root or vim.fs.dirname(fname))
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          root_dir = terraform_root,
          on_attach = function(client)
            client.server_capabilities.semanticTokensProvider = nil
          end,
        },
        tflint = {
          root_dir = terraform_root,
        },
      },
    },
  },
}
