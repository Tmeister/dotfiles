-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use phpactor as the PHP Language Server
vim.g.lazyvim_php_lsp = "phpactor"

-- Cursor line settings
vim.opt.cursorline = true

-- Performance optimizations
-- vim.opt.updatetime = 200 -- Removed: can cause popup delays
-- vim.opt.timeoutlen = 300 -- Removed: causes which-key popup delays
-- vim.opt.redrawtime = 1500 -- Removed: can affect UI responsiveness
-- vim.opt.lazyredraw = true -- Disabled: conflicts with Noice.nvim

-- Better search experience
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Override ignorecase if search contains uppercase
vim.opt.inccommand = "split" -- Live preview of substitution

-- Better splits behavior
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go to the right

-- Persistent undo
vim.opt.undofile = true -- Enable persistent undo
vim.opt.undolevels = 10000 -- Maximum number of undo levels

-- Better completion experience
vim.opt.completeopt = "menuone,noselect,preview" -- Better completion menu
vim.opt.pumheight = 10 -- Maximum items in popup menu

-- Scroll behavior
vim.opt.scrolloff = 8 -- Lines to keep above and below cursor
vim.opt.sidescrolloff = 8 -- Columns to keep to the left and right of cursor

-- Better diff experience
vim.opt.diffopt:append("linematch:60") -- Better diff algorithm

-- Word wrap settings
vim.opt.wrap = true -- Enable word wrap
vim.opt.linebreak = true -- Wrap at word boundaries
vim.opt.breakindent = true -- Preserve indentation in wrapped text
vim.opt.showbreak = "↪ " -- Show indicator for wrapped lines
