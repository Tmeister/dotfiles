local colors = require("user.theme").colors

require('bufferline').setup {
    options = {
        mode = "buffers",
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator_icon = "▎",
        buffer_close_icon = "",
        modified_icon = "",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        name_formatter = function(buf)
            if buf.name:match "%.md" then
                return vim.fn.fnamemodify(buf.name, ":t:r")
            end
        end,
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 25,
        diagnostics = false,
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            return " "
        end,
        offsets = {{
            filetype = "NvimTree",
            text = ""
        }},
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_buffer_default_icon = true,
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = {"", ""},
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        sort_by = "insert_at_end"
    },
    highlights = {
        fill = {
            fg = colors.fg,
            bg = colors.grey19
        },
        background = {
            fg = colors.fg,
            bg = colors.grey12
        },
        buffer_visible = {
            fg = colors.fg,
            bg = colors.grey12
        },
        buffer_selected = {
            fg = colors.fg,
            bg = colors.bg,
            bold = true
        },
        separator = {
            fg = colors.cyan,
            bg = colors.bg
        },
        separator_selected = {
            fg = colors.cyan,
            bg = colors.bg
        },
        separator_visible = {
            fg = colors.cyan,
            bg = colors.bg
        },
        close_button = {
            fg = colors.fg,
            bg = colors.grey12
        },
        close_button_selected = {
            fg = {
                attribute = "fg",
                highlight = "normal"
            },
            bg = {
                attribute = "bg",
                highlight = "normal"
            }
        },
        close_button_visible = {
            fg = {
                attribute = "fg",
                highlight = "normal"
            },
            bg = {
                attribute = "bg",
                highlight = "normal"
            }
        },
        duplicate = {
            fg = colors.grey9,
            bg = colors.grey12
        },
        duplicate_selected = {
            fg = colors.grey9,
            italic = true,
            bg = colors.bg
        },
        duplicate_visible = {
            fg = colors.grey9,
            italic = true,
            bg = colors.grey12
        },
        indicator_selected = {
            fg = colors.cyan,
            bg = colors.bg
        },
        modified = {
            fg = colors.grey11,
            bg = colors.grey12
        },
        modified_visible = {
            fg = colors.grey11,
            bg = colors.grey12
        },
        modified_selected = {
            fg = colors.grey10,
            bg = colors.bg
        }
    }
}
