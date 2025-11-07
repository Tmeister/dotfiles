-- Override nvim-treesitter configuration
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "OXY2DEV/markview.nvim",
  },
  opts = function(_, opts)
    -- Ensure these parsers are installed
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, {
      -- Web development
      "javascript",
      "typescript",
      "tsx",
      "jsx",
      "html",
      "css",
      "json",
      -- PHP
      "php",
      "phpdoc",
    })

    -- Enable syntax highlighting
    opts.highlight = opts.highlight or {}
    opts.highlight.enable = true

    -- Additional modules
    opts.indent = opts.indent or {}
    opts.indent.enable = true

    return opts
  end,
}
