return {
  -- Disable PHP CodeSniffer linting
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Remove phpcs from PHP linters
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.php = {}
      return opts
    end,
  },
  
  -- Also ensure phpcs is not installed by Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Remove phpcs from ensure_installed
      opts.ensure_installed = opts.ensure_installed or {}
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "phpcs"
      end, opts.ensure_installed)
      return opts
    end,
  },
}