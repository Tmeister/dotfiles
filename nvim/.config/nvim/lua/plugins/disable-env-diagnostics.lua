return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Create an autocommand group for LSP hacks
      local lsp_hacks = vim.api.nvim_create_augroup("LspHacks", { clear = true })

      -- Disable diagnostics for .env and .md files
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
        group = lsp_hacks,
        pattern = { ".env*", "*.md" },
        callback = function(e)
          vim.diagnostic.enable(false, { bufnr = e.buf })
        end,
      })

      return opts
    end,
  },
}