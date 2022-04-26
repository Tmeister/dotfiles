require('lualine').setup {
    options = {
        component_separators = '',
        theme = 'gruvbox-material',
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', {
            '',
        }, '"  " .. tostring(#vim.tbl_keys(vim.lsp.buf_get_clients()))', {
            'diagnostics',
            sources = {'nvim_diagnostic'}
        }, {
            '',
        }},
        lualine_c = {'filename'},
        lualine_x = {'filetype', 'encoding', 'fileformat'},
        lualine_y = {{
            '',
        }, '(vim.bo.expandtab and "␠ " or "⇥ ") .. " " .. vim.bo.shiftwidth', {
            ''
        }},
        lualine_z = {'location', 'progress'}
    }

}
