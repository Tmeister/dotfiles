return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  -- Don't set ft = "markdown" as it causes lazy loading
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local presets = require("markview.presets").headings
    require("markview").setup({
      preview = {
        icon_provider = "devicons",
      },
      markdown = {
        headings = presets.glow,
      },
    })
  end,
}