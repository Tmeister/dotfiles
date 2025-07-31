return {
  -- Disable snacks.nvim animations
  {
    "folke/snacks.nvim",
    opts = {
      animate = { enabled = false },
      scroll = { enabled = true },
      indent = { enabled = false },
      scope = { enabled = true },
      words = { enabled = true },
    },
  },
}
