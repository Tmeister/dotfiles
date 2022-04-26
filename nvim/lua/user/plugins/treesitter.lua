require('nvim-treesitter.configs').setup {
  ensure_installed = {
      'bash', 'python', 'lua', 'html', 'css', 'javascript', 'typescript', 'php',
      'dockerfile', 'json'
    },
  indent = {
    enable = { 'php', 'html', 'blade', 'javascript', 'css', 'scss', 'sass', 'typescript', 'javascriptreact', 'typescriptreact' },
  },
  highlight = {
    enable = true,
    disable = { 'NvimTree' },
    additional_vim_regex_highlighting = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['ia'] = '@parameter.inner',
      },
    },
  },
  context_commentstring = {
    enable = true,
  },
}