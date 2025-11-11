return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = false,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "vault-notes",
        path = "~/Documents/vault-notes",
      },
    },

    -- Disable obsidian UI to avoid conflicts with render-markdown.nvim
    ui = {
      enable = false,
    },
  },
}
