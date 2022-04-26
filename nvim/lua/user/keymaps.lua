local keymap = require 'lib.utils'.keymap

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap('n', '<leader>k', ':nohlsearch<CR>')
keymap('n', '<leader>Q', ':bufdo bdelete<CR>')

-- Allow gf to open non-existent files
keymap('', 'gf', ':edit <cfile><CR>')

-- Reselect visual selection after indenting
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- Maintain the cursor position when yanking a visual selection
-- http://ddrscott.github.io/blog/2016/yank-without-jank/
keymap('v', 'y', 'myy`hay')
keymap('v', 'Y', 'myY`y')

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Paste replace visual selection without copying it
keymap('v', 'p', '"_dP') -- TODO: vim-pasta is breaking this :(

-- Easy insertion of a trailing ; or , from insert mode
keymap('i', ';;', '<Esc>A;<Esc>')
keymap('i', ',,', '<Esc>A,<Esc>')

-- Disable annoying command line thing
keymap('n', 'q:', ':q<CR>')
-- Move text up and down
keymap('n', '<C-Down>', ':move .+1<CR>==') -- TODO: Something seems to be sending Alt occasionally and makes me mess up
keymap('n', '<C-Up>', ':move .-2<CR>==') -- TODO: Something seems to be sending Alt occasionally and makes me mess up
keymap('i', '<C-Down>', '<Esc>:move .+1<CR>==gi')
keymap('i', '<C-Up>', '<Esc>:move .-2<CR>==gi')
keymap('x', '<C-Down>', ":move '>+1<CR>gv-gv")
keymap('x', '<C-Up>', ":move '<-2<CR>gv-gv")