return {
  -- Disable emmet-ls LSP server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        emmet_ls = {
          -- Disable Emmet language server
          autostart = false,
        },
      },
    },
  },
  
  -- Remove emmet-ls from Mason auto-install list
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      opts.ensure_installed = vim.tbl_filter(function(server)
        return server ~= "emmet-ls"
      end, opts.ensure_installed)
      return opts
    end,
  },
}