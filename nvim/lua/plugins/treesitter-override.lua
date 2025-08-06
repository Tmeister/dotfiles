-- Override nvim-treesitter to depend on markview.nvim
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "OXY2DEV/markview.nvim",
  },
}