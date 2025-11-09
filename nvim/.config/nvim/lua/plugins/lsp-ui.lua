return {
  -- Configure LSP floating windows with borders
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Add borders to LSP floating windows
      local border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      }

      -- Override the default hover handler to add borders
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = border }
      )

      -- Also add borders to signature help
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = border }
      )

      -- Add border to diagnostics floating window
      vim.diagnostic.config({
        float = { border = border },
      })

      return opts
    end,
  },

  -- Configure Noice to use borders for LSP hover
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true, -- add border to hover docs and signature help
      },
    },
  },
}