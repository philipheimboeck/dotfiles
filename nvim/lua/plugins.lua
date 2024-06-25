vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })

vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "easymotion/vim-easymotion",
    "tanvirtin/monokai.nvim",
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equalent to setup({}) function
    },
    -- init.lua:
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8', -- or branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            local function diff_source()
                local gitsigns = vim.b.gitsigns_status_dict

                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed
                    }
                end
            end

            require('lualine').setup({
                sections = {
                    lualine_b = {
                        { 'b:gitsigns_head' },
                        { 'diff',           source = diff_source },
                        'diagnostics',
                    }
                },
                options = {
                    component_separators = '|',
                    disabled_filetypes = { 'dapui_stacks', 'dapui_scopes', 'dapui_watches', 'dapui_breakpoints', 'help' },
                    icons_enabled = false,
                    section_separators = '',
                }
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "bash",
                    "css",
                    "diff",
                    "dockerfile",
                    "dot",
                    "git_config",
                    "git_rebase",
                    "gitcommit",
                    "gitignore",
                    "html",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "php",
                    "javascript",
                    "typescript",
                    "sql",
                    "yaml",
                    "xml",
                },
                sync_install = false,
                highlight = { enable = true, additional_vim_regex_highlighting = false },
                indent = { enable = true },
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-context"
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                current_line_blame = true,
                on_attach = function()
                    vim.keymap.set('n', ']c', '<cmd>Gitsign next_hunk<cr>')
                    vim.keymap.set('n', '[c', '<cmd>Gitsign prev_hunk<cr>')
                end
            });
        end
    },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl",                 opts = {} },
    -- Vscode-like pictograms
    {
        "onsails/lspkind.nvim",
        event = { "VimEnter" },
    },
    -- Auto-completion engine
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "lspkind.nvim" },
        config = function()
            require("config.nvim-cmp")
        end,
    },
    { "hrsh7th/cmp-nvim-lsp",                dependencies = { "nvim-cmp" } },
    { "hrsh7th/cmp-buffer",                  dependencies = { "nvim-cmp" } }, -- buffer auto-completion
    { "hrsh7th/cmp-path",                    dependencies = { "nvim-cmp" } }, -- path auto-completion
    { "hrsh7th/cmp-cmdline",                 dependencies = { "nvim-cmp" } }, -- cmdline auto-completion
    -- {
    --     -- Code completion with AI
    --     'tzachar/cmp-ai',
    --     dependencies = 'nvim-lua/plenary.nvim',
    --     config = function()
    --         local cmp_ai = require('cmp_ai.config')

    --         cmp_ai:setup({
    --             max_lines = 100,
    --             provider = 'Ollama',
    --             provider_options = {
    --                 model = 'codellama:7b-code',
    --             },
    --             notify = true,
    --             notify_callback = function(msg)
    --                 vim.notify(msg)
    --             end,
    --             run_on_every_keystroke = true,
    --             ignored_file_types = {
    --                 -- default is not to ignore
    --                 -- uncomment to ignore in lua:
    --                 -- lua = true
    --             },
    --         })
    --     end
    -- },
    -- Code snippet engine
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
    },
    -- LSP manager
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    -- File Tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        config = function()
            vim.keymap.set('n', '<leader>fr', ':Neotree reveal<CR>', {})

            require('neo-tree').setup({
                filesystem = {
                    filtered_items = {
                        visible = true,
                    },
                },

                buffers = { follow_current_file = { enabled = true } }
            })
        end,
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require('lint').linters_by_ft = {
                markdown = { 'vale' },
                html = { 'tidy' },
                php = { 'phpstan' },
                typescript = { 'eslint' },
            }
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    -- try_lint without arguments runs the linters defined in `linters_by_ft`
                    -- for the current filetype
                    require("lint").try_lint(nil, { ignore_errors = true })
                end,
            })
        end
    },
    {
        "stevearc/conform.nvim",
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    php = { "pint" },
                },
                format_on_save = {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                },
                notify_on_error = true,
                formatters = {
                    pint = {
                        condition = function(self, ctx)
                            return not vim.fs.basename(ctx.filename):match('texts.php$')
                        end,
                    }
                }
            })
        end,
    },
    -- Useful plugin to show you pending keybinds.
    {
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            require('which-key').setup()

            -- Document existing key chains
            require('which-key').register {
                ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
                ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
                ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
                ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
                ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
                ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
                ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
            }
            -- visual mode
            require('which-key').register({
                ['<leader>h'] = { 'Git [H]unk' },
            }, { mode = 'v' })
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    -- Seperate plugin files
    require 'plugins.dap',
})
