vim.api.nvim_create_autocmd("BufWritePre", { command = [[:EslintFixAll]] })
