return {
  -- Configure Tailwind
  {
    dir = "~/Code/Sources/tailwind-vim",
    name = "tailwind",
    priority = 1000,
    opts = {
      flavour = "dark-enhanced", -- "light-default", "light-enhanced", "dark-default", "dark-enhanced", "auto"
      transparent_background = true,
      custom_highlights = function(colors)
        return {
          -- Use Tailwind's surface0 for a subtle dark cursor line
          CursorLine = { bg = colors.surface0 },
        }
      end,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        flash = true,
        mason = true,
        noice = true,
        which_key = true,
      },
    },
  },

  -- Configure LazyVim to use Tailwind
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tailwind",
    },
  },
}

-- return {
--   -- Configure Catppuccin
--   {
--     "catppuccin/nvim",
--     name = "catppuccin",
--     priority = 1000,
--     opts = {
--       flavour = "mocha", -- latte, frappe, macchiato, mocha
--       transparent_background = true,
--       custom_highlights = function(colors)
--         return {
--           -- Use Catppuccin's surface0 for a subtle dark cursor line
--           CursorLine = { bg = colors.surface0 },
--         }
--       end,
--       integrations = {
--         cmp = true,
--         gitsigns = true,
--         nvimtree = true,
--         treesitter = true,
--         notify = true,
--         mini = {
--           enabled = true,
--           indentscope_color = "",
--         },
--         flash = true,
--         mason = true,
--         noice = true,
--         which_key = true,
--       },
--     },
--   },
--
--   -- Configure LazyVim to use Catppuccin
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "catppuccin",
--     },
--   },
-- }
