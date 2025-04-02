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
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    "phpactor/phpactor",
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require('colorizer').setup();
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
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            animate = {},
            bigfile = {},
            dashboard = {},
            gitbrowse = {
                url_patterns = {
                    ["github%.com"] = {
                        branch = "/tree/{branch}",
                        file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
                        permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
                        commit = "/commit/{commit}",
                    },
                    ["gitlab%.com"] = {
                        branch = "/-/tree/{branch}",
                        file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
                        permalink = "/-/blob/{commit}/{file}#L{line_start}-L{line_end}",
                        commit = "/-/commit/{commit}",
                    },
                    ["git.abaservices.ch"] = {
                        branch = "/-/tree/{branch}",
                        file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
                        permalink = "/-/blob/{commit}/{file}#L{line_start}-L{line_end}",
                        commit = "/-/commit/{commit}",
                    }
                },
            },
            scroll = {},
            explorer = {
            },
            picker = {
                sources = {
                    files = {
                        hidden = true,
                        ignored = true,
                    },
                    grep = {
                        hidden = true,
                        ignored = false,
                    },
                    explorer = {
                        hidden = true,
                        ignored = true,
                        win = {
                            input = {
                                keys = {
                                    ["<esc>"] = { "", mode = "n" },
                                },
                            },
                            list = {
                                keys = {
                                    ["<esc>"] = { "", mode = "n" },
                                },
                            },
                        },

                    }
                }
            },
            indent = {},
            image = {},
            lazygit = {},
            notifier = {},
            quickfile = {},
            scope = {},
            scratch = {},
            statuscolumn = {},
            words = {},
        },
        keys = {
            -- Top Pickers & Explorer
            { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
            { "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
            { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
            { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
            { "<leader>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
            { "<leader>fe",      function() Snacks.explorer.reveal() end,                                desc = "File Explorer" },
            -- find
            { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
            { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
            { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
            { "<leader>fg",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
            { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
            { "<leader>fr",      function() Snacks.picker.recent({ filter = { cwd = true } }) end,       desc = "Recent" },
            -- git
            { "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
            { "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
            { "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
            { "<leader>gs",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
            { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
            { "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
            { "<leader>lg",      function() Snacks.lazygit() end,                                        desc = "Open Lazygit" },
            { "<leader>gB",      function() Snacks.gitbrowse() end,                                      desc = "Git open in remote" },
            -- Grep
            { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
            { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
            { "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
            { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
            -- search
            { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
            { '<leader>s/',      function() Snacks.picker.search_history() end,                          desc = "Search History" },
            { "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
            { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
            { "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
            { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
            { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
            { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
            { "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
            { "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
            { "<leader>si",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
            { "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
            { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
            { "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
            { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
            { "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
            { "<leader>sp",      function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
            { "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
            { "<leader>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
            { "<leader>su",      function() Snacks.picker.undo() end,                                    desc = "Undo History" },
            { "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
            -- LSP
            { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
            { "gD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
            { "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
            { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
            { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
            { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
            { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
            { "<leader>bd",      function() Snacks.bufdelete.delete() end,                               desc = 'Close buffer' },
            { "<leader>ba",      function() Snacks.bufdelete.all() end,                                  desc = 'Close all buffers' },
            { "<leader>bo",      function() Snacks.bufdelete.other() end,                                desc = 'Close other buffers' },
            -- scratch
            { "<leader>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
            { "<leader>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
        }
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
                    icons_enabled = true,
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
    { "hrsh7th/cmp-nvim-lsp", dependencies = { "nvim-cmp" } },
    { "hrsh7th/cmp-buffer",   dependencies = { "nvim-cmp" } }, -- buffer auto-completion
    { "hrsh7th/cmp-path",     dependencies = { "nvim-cmp" } }, -- path auto-completion
    { "hrsh7th/cmp-cmdline",  dependencies = { "nvim-cmp" } }, -- cmdline auto-completion
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
    --{
    --    "nvim-neotest/neotest",
    --    dependencies = {
    --        "nvim-neotest/nvim-nio",
    --        "nvim-lua/plenary.nvim",
    --        "antoinemadec/FixCursorHold.nvim",
    --        "nvim-treesitter/nvim-treesitter",
    --        "olimorris/neotest-phpunit",
    --        "mfussenegger/nvim-dap"
    --    },
    --    config = function()
    --        require('neotest').setup({
    --            adapters = {
    --                require('neotest-phpunit')({
    --                    --phpunit_cmd = function()
    --                    -- For Laravel projects
    --                    -- return 'vendor/bin/sail phpunit'
    --                   --end,
    --                    env = {
    --                        XDEBUG_CONFIG = 'idekey=neotest',
    --                        DB_HOST = '127.0.0.1',
    --                        DB_PORT = 54320
    --                    },
    --                    dap = require('dap').configurations.php[1],
    --                })
    --            }
    --        })
    --    end,
    --    keys = {
    --        { "<leader>t",  "",                                                                                 desc = "+test" },
    --        { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File (Neotest)" },
    --        { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end,                            desc = "Run All Test Files (Neotest)" },
    --        { "<leader>tr", function() require("neotest").run.run() end,                                        desc = "Run Nearest (Neotest)" },
    --        { "<leader>tl", function() require("neotest").run.run_last() end,                                   desc = "Run Last (Neotest)" },
    --        { "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary (Neotest)" },
    --        { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
    --        { "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "Toggle Output Panel (Neotest)" },
    --        { "<leader>tS", function() require("neotest").run.stop() end,                                       desc = "Stop (Neotest)" },
    --        { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end,                 desc = "Toggle Watch (Neotest)" },
    --    }
    --},
    require 'plugins.llm',
})
