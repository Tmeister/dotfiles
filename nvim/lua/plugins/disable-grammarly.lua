return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        grammarly = {
          -- Disable Grammarly language server
          autostart = false,
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Ensure grammarly-languageserver is not automatically installed
      opts.ensure_installed = opts.ensure_installed or {}
      opts.ensure_installed = vim.tbl_filter(function(server)
        return server ~= "grammarly-languageserver"
      end, opts.ensure_installed)
      return opts
    end,
  },
}