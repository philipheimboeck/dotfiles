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
        "nvim-lua/plenary.nvim",
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
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require('bufferline').setup({
                options = {
                    mode = 'buffers',
                    offsets = {
                        {
                            filetype = 'neo-tree',
                            text = 'File Explorer',
                            separator = true,
                            text_align = 'left'
                        }
                    },
                    diagnostics = "nvim_lsp",
                }
            })
        end
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
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-smart-history.nvim', "nvim-telescope/telescope-live-grep-args.nvim", },
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
            telescope.load_extension("live_grep_args")
            telescope.load_extension('smart_history')

            local builtin = require('telescope.builtin')

            vim.keymap.set('n', '<leader>F', builtin.resume, { desc = 'Resume search' })
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files...' })
            vim.keymap.set('n', '<leader>fF', builtin.oldfiles, { desc = 'Find recent files...' })
            -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Find in files...' })
            vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args,
                { desc = 'Find in files' })
            vim.keymap.set('n', '<leader>fG', builtin.git_status, { desc = 'Find changed files...' })
            vim.keymap.set('n', '<leader>fd', builtin.lsp_references, { desc = 'Find LSP references...' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers...' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find help...' })
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
                "comment",
                "bash",
                "blade",
                "css",
                "diff",
                "dockerfile",
                "dot",
                "editorconfig",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "html",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "scss",
                "php",
                "php_only",
                "fish",
                "javascript",
                "typescript",
                "regex",
                "sql",
                "yaml",
                "vue",
                "xml",
                "json",
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
                    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Git stage hunk' })
                    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Git reset hunk' })
                    map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                        { desc = 'Git stage hunk' })
                    map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                        { desc = 'Git reset hunk' })
                    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Git stage buffer' })
                    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Git reset buffer' })
                    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Git preview hunk' })
                    map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end,
                        { desc = 'Git blame line' })
                    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Git toggle current line blame' })
                    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Git diff' })
                    map('n', '<leader>hD', function() gitsigns.diffthis('~') end, { desc = 'Git diff current file' })
                    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Git preview hunk' })
                    map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'Git preview hunk inline' })

                    -- Text object
                    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Git select hunk' })
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
            vim.keymap.set('n', '<leader>fr', ':Neotree reveal<CR>', { desc = 'Neotree reveal' })

            local function getTelescopeOpts(state, path)
                return {
                    cwd = path,
                    search_dirs = { path },
                    attach_mappings = function(prompt_bufnr, map)
                        local actions = require "telescope.actions"
                        actions.select_default:replace(function()
                            actions.close(prompt_bufnr)
                            local action_state = require "telescope.actions.state"
                            local selection = action_state.get_selected_entry()
                            local filename = selection.filename
                            if (filename == nil) then
                                filename = selection[1]
                            end
                            -- any way to open the file without triggering auto-close event of neo-tree?
                            require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
                        end)
                        return true
                    end
                }
            end

            require('neo-tree').setup({
                filesystem = {
                    filtered_items = {
                        visible = true,
                    },
                    follow_current_file = { enabled = true },
                    use_libuv_file_watcher = true,
                    window = {
                        mappings = {
                            ["g"] = "telescope_grep",
                            ["f"] = "telescope_find",
                        }
                    }
                },
                commands = {
                    telescope_find = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        require('telescope.builtin').find_files(getTelescopeOpts(state, path))
                    end,
                    telescope_grep = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        require('telescope.builtin').live_grep(getTelescopeOpts(state, path))
                    end,
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
            require 'window-picker'.setup(
                {
                    hint = 'floating-big-letter'
                }
            )
        end,
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.env.ESLINT_D_PPID = vim.fn.getpid()

            require('lint').linters_by_ft = {
                markdown = { 'vale' },
                html = { 'tidy' },
                php = { 'phpstan' },
                typescript = { 'eslint_d' },
                javascript = { 'eslint_d' },
                vue = { 'eslint_d' },
                fish = { 'fish' },
                zsh = { 'zsh' },
                bash = { 'bash' },
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
                    typescript = { "eslint_d" },
                    vue = { "eslint_d" },
                    json = { "fixjson" },
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
                            return not ctx.filename:match('.*/lang/.*.php$')
                        end,
                    },
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
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = 'helix',
            spec = {
                { '<leader>f', group = 'file' },
                { '<leader>h', group = 'Git' },
            }
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    require 'plugins.dap',
    -- require 'plugins.llm',
})
