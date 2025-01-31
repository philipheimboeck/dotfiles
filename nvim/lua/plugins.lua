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
    {
        "ellisonleao/dotenv.nvim",
        config = function()
            require('dotenv').setup({
                enable_on_load = true,
                verbose = false,
            })
        end
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta",                        lazy = true }, -- optional `vim.uv` typings
    {                                                               -- optional completion source for require statements and module annotations
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
    "phpactor/phpactor",
    {
        "j-hui/fidget.nvim",
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require('colorizer').setup();
        end
    },
    -- Subword motions
    {
        "chrisgrieser/nvim-spider",
        keys = {
            {
                "w",
                "<cmd>lua require('spider').motion('w')<CR>",
                mode = { "n", "o", "x" },
            },
            {
                "e",
                "<cmd>lua require('spider').motion('e')<CR>",
                mode = { "n", "o", "x" },
            },
            {
                "b",
                "<cmd>lua require('spider').motion('b')<CR>",
                mode = { "n", "o", "x" },
            }
        },
        config = function()
            -- Map original word motion (w) to W
            vim.keymap.set({ 'n', 'o', 'x' }, 'W', 'w', { noremap = true })

            require('spider').setup({
                skipInsignificantPunctuation = false
            })
        end
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for../../colors/ passing setup options
        -- this is equalent to setup({}) function
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8', -- or branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-smart-history.nvim' },
        config = function()
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    -- configure to use ripgrep
                    vimgrep_arguments = {
                        "rg",
                        "--follow",        -- Follow symbolic links
                        "--hidden",        -- Search for hidden files
                        "--no-heading",    -- Don't group matches by each file
                        "--with-filename", -- Print the file path with the matched lines
                        "--line-number",   -- Show line numbers
                        "--column",        -- Show column numbers
                        "--smart-case",    -- Smart case search
                        "-u",              -- Disable .gitignore handling


                        -- Exclude some patterns from search
                        "--glob=!**/.git/*",
                        "--glob=!**/.idea/*",
                        "--glob=!**/.vscode/*",
                        "--glob=!**/build/*",
                        "--glob=!**/dist/*",
                        "--glob=!**/yarn.lock",
                        "--glob=!**/package-lock.json",
                        "--glob=!**/node_modules/*",
                        "--glob=!**/vendor/*",
                    },
                    history = {
                        path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
                        limit = 100,
                    }
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        find_command = {
                            "rg",
                            "--files",
                            "--hidden",
                            "--glob=!**/.git/*",
                            "--glob=!**/.idea/*",
                            "--glob=!**/.vscode/*",
                            "--glob=!**/build/*",
                            "--glob=!**/dist/*",
                            "--glob=!**/yarn.lock",
                            "--glob=!**/package-lock.json",
                            "--glob=!**/node_modules/*",
                            "--glob=!**/vendor/*",
                        },
                    }
                },
                mappings = {
                    i = {
                        ["<M-Down>"] = require('telescope.actions').cycle_history_next,
                        ["<M-Up>"] = require('telescope.actions').cycle_history_prev,
                    }
                }
            })
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>F', builtin.resume, {})
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fF', builtin.oldfiles, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fG', builtin.git_status, {})
            vim.keymap.set('n', '<leader>fd', builtin.lsp_references, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

            require('telescope').load_extension('smart_history')
        end
    },
    { 'nvim-telescope/telescope-smart-history.nvim', dependencies = { 'kkharji/sqlite.lua' } },
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
        opts = {
            ensure_installed = {
                "bash",
                "blade",
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
                "scss",
                "php",
                "javascript",
                "typescript",
                "sql",
                "yaml",
                "vue",
                "xml",
            },
            sync_install = false,
            highlight = { enable = true, additional_vim_regex_highlighting = false },
            indent = { enable = true },
        },
        config = function(_, opts)
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.blade = {
                install_info = {
                    url = "https://github.com/EmranMR/tree-sitter-blade",
                    files = { "src/parser.c" },
                    branch = "main",
                },
                filetype = "blade"
            }

            vim.filetype.add({
                pattern = {
                    ['.*%.blade%.php'] = 'blade',
                }
            })

            require('nvim-treesitter.configs').setup(opts)
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
                    local gitsigns = require('gitsigns')

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map('n', ']c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ ']c', bang = true })
                        else
                            gitsigns.nav_hunk('next')
                        end
                    end)

                    map('n', '[c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ '[c', bang = true })
                        else
                            gitsigns.nav_hunk('prev')
                        end
                    end)

                    -- Actions
                    map('n', '<leader>hs', gitsigns.stage_hunk)
                    map('n', '<leader>hr', gitsigns.reset_hunk)
                    map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                    map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                    map('n', '<leader>hS', gitsigns.stage_buffer)
                    map('n', '<leader>hu', gitsigns.undo_stage_hunk)
                    map('n', '<leader>hR', gitsigns.reset_buffer)
                    map('n', '<leader>hp', gitsigns.preview_hunk)
                    map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end)
                    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
                    map('n', '<leader>hd', gitsigns.diffthis)
                    map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
                    map('n', '<leader>td', gitsigns.toggle_deleted)

                    -- Text object
                    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
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
    { "saadparwaiz1/cmp_luasnip" },
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
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },
    -- LSP manager
    {
        "williamboman/mason.nvim",
        config = function()
            require('mason').setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }

            })
        end
    },
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
                    follow_current_file = { enabled = true },
                    use_libuv_file_watcher = true,
                },
                buffers = { follow_current_file = { enabled = true } }
            })
        end,
    },
    {
        's1n7ax/nvim-window-picker',
        name = 'window-picker',
        event = 'VeryLazy',
        version = '2.*',
        config = function()
            require 'window-picker'.setup()
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
            require('lint').linters.phpstan.args = {
                'analyze',
                '--error-format=json',
                '--no-progress',
                '--memory-limit=-1',
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
                    php = { "php_cs_fixer" },
                },
                format_on_save = {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                },
                notify_on_error = true,
                formatters = {
                    php_cs_fixer = {
                        condition = function(self, ctx)
                            return not vim.fs.basename(ctx.filename):match('texts.php$')
                        end,
                    }
                }
            })
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    { "RRethy/vim-illuminate" },
    {
        "tpope/vim-fugitive",
        dependencies = { "shumphrey/fugitive-gitlab.vim" },
        config = function()
            vim.cmd([[
              let g:fugitive_gitlab_domains = ['git.abaservices.ch']
            ]])
        end,
    },
    -- Seperate plugin files
    require 'plugins.dap',
    -- require 'plugins.llm',
})
