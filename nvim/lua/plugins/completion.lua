return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "accept", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        -- Disable default C-n/C-p if you only want arrows
        ["<C-n>"] = {},
        ["<C-p>"] = {},
      },
    },
  },
}