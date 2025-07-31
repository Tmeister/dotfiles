return {
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "kevinhwang91/promise-async",
    },
    cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    keys = {
      { "<leader>La", "<cmd>Laravel artisan<cr>", desc = "Laravel artisan" },
      { "<leader>Lr", "<cmd>Laravel routes<cr>", desc = "Laravel routes" },
      { "<leader>Lc", "<cmd>Laravel composer<cr>", desc = "Laravel composer" },
      { "<leader>Ln", "<cmd>Laravel npm<cr>", desc = "Laravel npm" },
    },
    event = { "VeryLazy" },
    opts = {
      lsp_server = "phpactor",
      features = {
        null_ls = {
          enable = false,
        },
        route_info = {
          enable = false,  -- This disables the inline route hints
        },
      },
    },
    config = function(_, opts)
      require("laravel").setup(opts)
    end,
  },
}