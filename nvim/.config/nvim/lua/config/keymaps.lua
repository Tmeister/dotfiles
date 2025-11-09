-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Window navigation is handled by LazyVim defaults (<C-h/j/k/l>)

-- Line movement is handled by LazyVim defaults (<A-j/k>)
-- Adding arrow key alternatives for convenience
vim.keymap.set("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-Down>", "<cmd>m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-Up>", "<cmd>m '<-2<cr>gv=gv", { desc = "Move selection up" })
vim.keymap.set("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohl<cr>", { desc = "Clear search highlight" })

-- Save file is handled by LazyVim defaults (<C-s>)
-- Adding additional modes for convenience
vim.keymap.set("i", "<C-s>", "<Esc><cmd>w<cr>a", { desc = "Save file" })
vim.keymap.set("v", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })

-- Linux specific keymaps optimized for 75% keyboard
-- These work better on Linux terminals

-- Delete word backward (Ctrl+Backspace - standard Linux)
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })
vim.keymap.set("i", "<C-H>", "<C-w>", { desc = "Delete word backward (alt)" })

-- Delete to end of line (Ctrl+Shift+K to avoid LSP conflicts)
vim.keymap.set("i", "<C-S-k>", "<C-o>D", { desc = "Delete to end of line" })

-- Better paste
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Select all
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" })
vim.keymap.set("v", "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- Quick close buffer
vim.keymap.set("n", "<leader>q", "<cmd>bd<cr>", { desc = "Close buffer" })

-- Toggle line wrapping
vim.keymap.set("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle word wrap" })

-- Center screen after moving
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Join lines without moving cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

-- Keep cursor in the middle when scrolling
vim.keymap.set("n", "{", "{zz", { desc = "Previous paragraph and center" })
vim.keymap.set("n", "}", "}zz", { desc = "Next paragraph and center" })

-- Split windows (LazyVim uses <leader>| and <leader>-)
-- Keeping these as alternatives
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split window horizontally" })

-- Navigate between splits using Ctrl + arrow keys
vim.keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Navigate to upper split" })
vim.keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Navigate to lower split" })
vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Navigate to left split" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Navigate to right split" })

-- Resize splits (using leader key for reliability)
vim.keymap.set("n", "<leader>+", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<leader>-", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
vim.keymap.set("n", "<leader><", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })

-- Duplicate lines (Ctrl+D in insert mode, avoiding conflicts)
vim.keymap.set("n", "<leader>d", "<cmd>t.<cr>", { desc = "Duplicate line down" })
vim.keymap.set("v", "<leader>d", "<cmd>t'><cr>gv", { desc = "Duplicate selection down" })

-- Quick buffer navigation
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Change/delete without yanking (using black hole register)
vim.keymap.set("n", "c", '"_c', { desc = "Change without yank" })
vim.keymap.set("n", "C", '"_C', { desc = "Change to end of line without yank" })
vim.keymap.set("v", "c", '"_c', { desc = "Change without yank" })

-- Obsidian.nvim keymaps
-- Main commands
vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "Obsidian: New note" })
vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian quick_switch<cr>", { desc = "Obsidian: Quick switch" })
vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Obsidian: Search" })
vim.keymap.set("n", "<leader>of", "<cmd>Obsidian follow_link<cr>", { desc = "Obsidian: Follow link" })

-- Daily notes
vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian today<cr>", { desc = "Obsidian: Today's note" })
vim.keymap.set("n", "<leader>oy", "<cmd>Obsidian yesterday<cr>", { desc = "Obsidian: Yesterday's note" })
vim.keymap.set("n", "<leader>om", "<cmd>Obsidian tomorrow<cr>", { desc = "Obsidian: Tomorrow's note" })

-- Navigation
vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Obsidian: Backlinks" })
vim.keymap.set("n", "<leader>ol", "<cmd>Obsidian links<cr>", { desc = "Obsidian: Links in current note" })
vim.keymap.set("n", "<leader>oc", "<cmd>Obsidian toc<cr>", { desc = "Obsidian: Table of contents" })

-- Visual mode commands
vim.keymap.set("v", "<leader>ol", "<cmd>Obsidian link<cr>", { desc = "Obsidian: Link selection" })
vim.keymap.set("v", "<leader>on", "<cmd>Obsidian link_new<cr>", { desc = "Obsidian: New note from selection" })
vim.keymap.set("v", "<leader>oe", "<cmd>Obsidian extract_note<cr>", { desc = "Obsidian: Extract to new note" })

-- Other useful commands
vim.keymap.set("n", "<leader>or", "<cmd>Obsidian rename<cr>", { desc = "Obsidian: Rename note" })
vim.keymap.set("n", "<leader>op", "<cmd>Obsidian paste_img<cr>", { desc = "Obsidian: Paste image" })
vim.keymap.set("n", "<leader>ox", "<cmd>Obsidian toggle_checkbox<cr>", { desc = "Obsidian: Toggle checkbox" })
vim.keymap.set("n", "<leader>oT", "<cmd>Obsidian template<cr>", { desc = "Obsidian: Insert template" })
vim.keymap.set("n", "<leader>og", "<cmd>Obsidian tags<cr>", { desc = "Obsidian: Search tags" })
