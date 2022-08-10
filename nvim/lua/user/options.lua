-- local theme = require "user.theme"

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.signcolumn = 'yes:2'
vim.o.relativenumber = true
vim.o.number = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.spell = true
vim.o.title = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wildmode = 'longest:full,full'
vim.o.wrap = true
vim.o.list = true
vim.o.listchars = 'tab:▸ ,trail:·'
vim.o.mouse = 'a'
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.clipboard = 'unnamedplus' -- Use Linux system clipboard
vim.o.confirm = true
vim.o.backup = true
vim.o.backupdir = vim.fn.stdpath 'data' .. '/backup//'
vim.o.updatetime = 250          -- Decrease CursorHold delay
vim.o.redrawtime = 10000        -- Allow more time for loading syntax on large files
vim.o.showmode = false
vim.o.fillchars = 'eob: '

-- Theme / Keep BG transparent
vim.api.nvim_command([[
    augroup ChangeBackgroudColour
        autocmd colorscheme * :hi normal guibg=none
    augroup END
]])

-- On Save, delete trailing whitespace and format with Prettier
vim.api.nvim_command([[
    augroup TrimSpaces
        autocmd BufWritePre * :%s/\s\+$//e
    augroup END
]])

vim.o.termguicolors = true

--  Theme
vim.g.catppuccin_flavour = "frappe" -- latte, frappe, macchiato, mocha
require("catppuccin").setup()
vim.cmd [[colorscheme catppuccin]]

-- theme.init()