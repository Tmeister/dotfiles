return {
  -- Blade syntax highlighting for Laravel templates
  {
    "jwalton512/vim-blade",
    ft = "blade",
  },


  -- Prettier formatting
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- Add prettier for web formats
      opts.formatters_by_ft.javascript = { "prettier" }
      opts.formatters_by_ft.javascriptreact = { "prettier" }
      opts.formatters_by_ft.typescript = { "prettier" }
      opts.formatters_by_ft.typescriptreact = { "prettier" }
      opts.formatters_by_ft.css = { "prettier" }
      opts.formatters_by_ft.scss = { "prettier" }
      opts.formatters_by_ft.html = { "prettier" }
      opts.formatters_by_ft.json = { "prettier" }
      opts.formatters_by_ft.yaml = { "prettier" }
      opts.formatters_by_ft.markdown = { "prettier" }
      opts.formatters_by_ft.blade = { "blade-formatter" }
      
      -- Smart PHP formatting selection
      opts.formatters_by_ft.php = function(bufnr)
        local config_file = vim.fn.findfile(".php-cs-fixer.dist.php", vim.fn.expand("%:p:h") .. ";")
        if config_file ~= "" then
          return { "php_cs_fixer" }
        else
          return { "pint" }
        end
      end
      
      -- Configure formatters
      opts.formatters = {
        pint = {
          command = "pint",
          args = { "$FILENAME" },
          stdin = false,
        },
        php_cs_fixer = {
          command = "php-cs-fixer",
          args = function(self, ctx)
            local config_file = vim.fn.findfile(".php-cs-fixer.dist.php", ctx.dirname .. ";")
            return { "fix", "$FILENAME", "--config=" .. config_file }
          end,
          stdin = false,
        },
      }
      
      return opts
    end,
  },

  -- Emmet support
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, {
            "emmet-ls",
            "prettier",
            "blade-formatter",
            "pint",
            "php-cs-fixer",
          })
        end,
      },
    },
    opts = {
      servers = {
        emmet_ls = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "blade",
            "php",
          },
        },
      },
    },
  },

  -- Database integration
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- REST client
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    keys = {
      { "<leader>R", "", desc = "+Rest" },
      { "<leader>Rs", "<cmd>lua require('kulala').run()<cr>", desc = "Send the request" },
      { "<leader>Rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle headers/body" },
      { "<leader>Rp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "Previous request" },
      { "<leader>Rn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Next request" },
    },
    opts = {},
  },
}