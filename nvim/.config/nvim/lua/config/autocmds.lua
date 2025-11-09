-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-save on focus lost (disabled - causes delays)
-- vim.api.nvim_create_autocmd({ "FocusLost" }, {
--   pattern = "*",
--   command = "silent! wa",
--   desc = "Auto-save all buffers on focus lost",
-- })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
  desc = "Highlight yanked text",
})

-- Auto-create directories when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    local dir = vim.fn.fnamemodify(args.file, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
  desc = "Auto-create parent directories when saving",
})

-- Remove auto-comment on new lines for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "php", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
  desc = "Disable auto-comment on new lines",
})

-- Auto-format PHP files on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.php",
  callback = function()
    require("conform").format({ bufnr = 0, lsp_fallback = true })
  end,
  desc = "Auto-format PHP files on save",
})

