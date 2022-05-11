local M = {}

M.keymap = function(mode, lhs, rhs, opts)
  vim.api.nvim_set_keymap(
    mode,
    lhs,
    rhs,
    vim.tbl_extend('keep', opts or {}, { noremap = true, silent = true })
  )
end

M.buf_keymap = function(bufnr, mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    mode,
    lhs,
    rhs,
    vim.tbl_extend('keep', opts or {}, { noremap = true, silent = true })
  )
end

M.signs = { Error = "", Warn = "", Hint = "", Info = "" }

M.setSpacesSize = function(filetypes)
    for filetype, size in pairs(filetypes) do
        vim.api.nvim_create_autocmd("FileType", {
            pattern = filetype,
            callback = function()
                vim.opt.shiftwidth = size
                vim.opt.tabstop = size
            end,
        })
    end
end

return M