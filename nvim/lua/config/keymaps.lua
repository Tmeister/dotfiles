-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Disable default behavior of space
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Move lines up and down
-- Normal mode
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move line up" })

-- Visual mode
vim.keymap.set("v", "<A-j>", "<cmd>m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", "<cmd>m '<-2<cr>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<A-Down>", "<cmd>m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-Up>", "<cmd>m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Insert mode
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
vim.keymap.set("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohl<cr>", { desc = "Clear search highlight" })

-- Save file
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<Esc><cmd>w<cr>a", { desc = "Save file" })
vim.keymap.set("v", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })

-- macOS specific keymaps using Option/Alt key
-- These work better on macOS terminals

-- Delete word backward (Option+Backspace)
vim.keymap.set("i", "<A-BS>", "<C-w>", { desc = "Delete word backward" })

-- Move to beginning/end of line
vim.keymap.set("i", "<A-Left>", "<C-o>^", { desc = "Move to beginning of line" })
vim.keymap.set("i", "<A-Right>", "<C-o>$", { desc = "Move to end of line" })
vim.keymap.set("n", "<A-Left>", "^", { desc = "Move to beginning of line" })
vim.keymap.set("n", "<A-Right>", "$", { desc = "Move to end of line" })

-- Move word by word
vim.keymap.set("i", "<A-b>", "<C-o>b", { desc = "Move word backward" })
vim.keymap.set("i", "<A-f>", "<C-o>w", { desc = "Move word forward" })
vim.keymap.set("n", "<A-b>", "b", { desc = "Move word backward" })
vim.keymap.set("n", "<A-f>", "w", { desc = "Move word forward" })

-- Delete to end of line
vim.keymap.set("i", "<A-d>", "<C-o>D", { desc = "Delete to end of line" })
vim.keymap.set("n", "<A-d>", "D", { desc = "Delete to end of line" })

-- Better paste
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Duplicate lines
vim.keymap.set("n", "<A-S-Down>", "<cmd>t.<cr>", { desc = "Duplicate line down" })
vim.keymap.set("n", "<A-S-Up>", "<cmd>t-1<cr>", { desc = "Duplicate line up" })
vim.keymap.set("n", "<A-S-j>", "<cmd>t.<cr>", { desc = "Duplicate line down" })
vim.keymap.set("n", "<A-S-k>", "<cmd>t-1<cr>", { desc = "Duplicate line up" })

vim.keymap.set("v", "<A-S-Down>", "<cmd>t'><cr>gv", { desc = "Duplicate selection down" })
vim.keymap.set("v", "<A-S-Up>", ":<C-u>'<,'>t'<-1<CR>gv", { desc = "Duplicate selection up" })
vim.keymap.set("v", "<A-S-j>", "<cmd>t'><cr>gv", { desc = "Duplicate selection down" })
vim.keymap.set("v", "<A-S-k>", ":<C-u>'<,'>t'<-1<CR>gv", { desc = "Duplicate selection up" })

vim.keymap.set("i", "<A-S-Down>", "<Esc>:t.<CR>gi", { desc = "Duplicate line down" })
vim.keymap.set("i", "<A-S-Up>", "<Esc>:t-1<CR>gi", { desc = "Duplicate line up" })
vim.keymap.set("i", "<A-S-j>", "<Esc>:t.<CR>gi", { desc = "Duplicate line down" })
vim.keymap.set("i", "<A-S-k>", "<Esc>:t-1<CR>gi", { desc = "Duplicate line up" })

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

-- Split windows
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split window horizontally" })

-- Navigate between splits using Ctrl + arrow keys
vim.keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Navigate to upper split" })
vim.keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Navigate to lower split" })
vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Navigate to left split" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Navigate to right split" })

-- Resize splits with Option/Alt + Shift + arrows
vim.keymap.set("n", "<A-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<A-S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<A-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<A-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Quick buffer navigation
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

