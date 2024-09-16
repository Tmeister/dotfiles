local packer = require 'lib.packer-init'

packer.startup(function(use)
    use {'wbthomason/packer.nvim'} -- Let packer manage itself
    use {'tpope/vim-commentary'}
    use {'tpope/vim-surround'}
    use {'tpope/vim-sleuth'}
    use {'nelstrom/vim-visual-star-search'}
    use {'rafamadriz/friendly-snippets'}
    use {'saadparwaiz1/cmp_luasnip'}
    use {'jwalton512/vim-blade'}
    use {'wuelnerdotexe/vim-astro'}
    use {
        'github/copilot.vim',
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")',
                                    {silent = true, expr = true})
        end
    }
    use {"catppuccin/nvim", as = "catppuccin"}
    use {
        "rmehri01/onenord.nvim",
        config = function() require('user.plugins.onenord') end
    }

    use {
        'prettier/vim-prettier',
        ft = {
            'javascript', 'typescript', 'css', 'less', 'scss', 'graphql',
            'markdown', 'vue', 'html', 'json', 'yaml', 'toml', 'yml', 'xml'
        }
    }

    use {
        'sickill/vim-pasta',
        config = function() vim.g.pasta_disabled_filetypes = {'fugitive'} end
    }

    use {
        'jessarcher/vim-sayonara',
        config = function() require('user.plugins.sayonara') end
    }

    use {
        'AndrewRadev/splitjoin.vim',
        config = function()
            vim.g.splitjoin_html_attributes_bracket_on_new_line = 1
        end
    }

    use {
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup() end
    }

    use {
        'windwp/nvim-ts-autotag',
        config = function() require('nvim-ts-autotag').setup() end
    }

    use {
        'akinsho/bufferline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function() require('user.plugins.bufferline') end
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function() require('user.plugins.lualine') end
    }

    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function() require('user.plugins.nvim-tree') end
    }

    use {
        'karb94/neoscroll.nvim',
        config = function() require('user.plugins.neoscroll') end
    }

    use {
        'voldikss/vim-floaterm',
        config = function() require('user.plugins.floaterm') end
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'}, {'kyazdani42/nvim-web-devicons'},
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
            {'nvim-telescope/telescope-live-grep-raw.nvim'}
        },
        config = function() require('user.plugins.telescope') end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        requires = {
            'nvim-treesitter/playground',
            'nvim-treesitter/nvim-treesitter-textobjects',
            'lewis6991/spellsitter.nvim',
            'JoosepAlviste/nvim-ts-context-commentstring'
        },
        config = function()
            require('user.plugins.treesitter')
            require('spellsitter').setup()
        end
    }

    use {'tpope/vim-fugitive', requires = 'tpope/vim-rhubarb', cmd = 'G'}

    use {
        'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('gitsigns').setup {sign_priority = 20}
        end
    }

    use {
        'neovim/nvim-lspconfig',
        requires = {
            'b0o/schemastore.nvim', 'folke/lsp-colors.nvim',
            'weilbith/nvim-code-action-menu'
        },
        config = function() require('user.plugins.lspconfig') end
    }

    use {
        'j-hui/fidget.nvim',
        config = function() require('fidget').setup {} end
    }

    use {
        'L3MON4D3/LuaSnip',
        config = function() require('user.plugins.luasnip') end
    }

    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer',
            'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-nvim-lua',
            'onsails/lspkind-nvim', 'hrsh7th/cmp-nvim-lsp-signature-help'
        },
        config = function() require('user.plugins.cmp') end
    }

    use {
        'phpactor/phpactor',
        branch = 'master',
        ft = 'php',
        run = 'composer install --no-dev -o',
        config = function() require('user.plugins.phpactor') end
    }

end)
