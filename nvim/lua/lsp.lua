require('mason-lspconfig').setup({
    -- A list of servers to automatically install if they're not already installed
    ensure_installed = { 'lua_ls', 'bashls', 'ts_ls', 'yamlls', 'volar', 'html', 'phpactor', 'intelephense', 'volar' },
    automatic_installation = true
})


-- Set different settings for different languages' LSP
-- LSP list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- How to use setup({}): https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
--     - the settings table is sent to the LSP
--     - on_attach: a lua callback function to run after LSP attaches to a given buffer
local lspconfig = require("lspconfig")

-- Customized on_attach function
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Inlay hints
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr })
        vim.keymap.set(
            "n",
            "<leader>gh",
            function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
            end,
            { desc = "Toggle Inlay Hints" }
        )
    end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    --vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, { unpack(bufopts), desc = 'Go to type definition' })
    --vim.keymap.set("n", "gK", vim.lsp.buf.declaration, { unpack(bufopts), desc = 'Go to declaration' })
    --vim.keymap.set("n", "gd", vim.lsp.buf.definition, { unpack(bufopts), desc = 'Go to definition' })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { unpack(bufopts), desc = 'Hover' })
    --vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { unpack(bufopts), desc = 'See implementations' })
    --vim.keymap.set("n", "gr", vim.lsp.buf.references, { unpack(bufopts), desc = 'See references' })
    vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, { unpack(bufopts), desc = 'Signature help' })
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,
        { unpack(bufopts), desc = 'Workspace add folder' })
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,
        { unpack(bufopts), desc = 'Workspace remove folder' })
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { unpack(bufopts), desc = 'Workspace folders' })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { unpack(bufopts), desc = 'Rename' })
    vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { unpack(bufopts), desc = 'Code Action' })
    vim.keymap.set("n", "<leader>gq", function()
        require("conform").format()
    end, { unpack(bufopts), desc = 'Format...' })
end

-- How to add a LSP for a specific language?
-- 1. Use `:Mason` to install the corresponding LSP.
-- 2. Add configuration below.
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

local capabilitites = require('cmp_nvim_lsp').default_capabilities();

lspconfig.bashls.setup({})

--[[
lspconfig.phpactor.setup({
    on_attach = on_attach,
    capabilitites = capabilitites,
})
]]

lspconfig.intelephense.setup({
    on_attach = on_attach,
    capabilitites = capabilitites,
    settings = {
        intelephense = {
            references = {
                exclude = { '**/vendor/**/{Tests,tests}/**' }
            }
        }
    }
})

lspconfig.volar.setup({
    on_attach = on_attach,
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    init_options = {
        vue = {
            hybridMode = true,
        },
    },
})

lspconfig.ts_ls.setup({
    on_attach = on_attach,
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = "/opt/homebrew/lib/node_modules/@vue/typescript-plugin",
                languages = { "javascript", "typescript", "vue" },
            },
        },
    },
})



-- LSP Info
local Float = require "plenary.window.float"

vim.cmd([[
    augroup LspPhpactor
      autocmd!
      autocmd Filetype php command! -nargs=0 LspPhpactorReindex lua vim.lsp.buf_notify(0, "phpactor/indexer/reindex",{})
      autocmd Filetype php command! -nargs=0 LspPhpactorConfig lua LspPhpactorDumpConfig()
      autocmd Filetype php command! -nargs=0 LspPhpactorStatus lua LspPhpactorStatus()
      autocmd Filetype php command! -nargs=0 LspPhpactorBlackfireStart lua LspPhpactorBlackfireStart()
      autocmd Filetype php command! -nargs=0 LspPhpactorBlackfireFinish lua LspPhpactorBlackfireFinish()
    augroup END
]])

local function showWindow(title, syntax, contents)
    local out = {};
    for match in string.gmatch(contents, "[^\n]+") do
        table.insert(out, match);
    end

    local float = Float.percentage_range_window(0.6, 0.4, { winblend = 0 }, {
        title = title,
        topleft = "┌",
        topright = "┐",
        top = "─",
        left = "│",
        right = "│",
        botleft = "└",
        botright = "┘",
        bot = "─",
    })

    vim.api.nvim_set_option_value("filetype", syntax, { buf = float.bufnr })
    vim.api.nvim_buf_set_lines(float.bufnr, 0, -1, false, out)
end

function LspPhpactorDumpConfig()
    local results, _ = vim.lsp.buf_request_sync(0, "phpactor/debug/config", { ["return"] = true })
    for _, res in pairs(results or {}) do
        pcall(showWindow, 'Phpactor LSP Configuration', 'json', res['result'])
    end
end

function LspPhpactorStatus()
    local results, _ = vim.lsp.buf_request_sync(0, "phpactor/status", { ["return"] = true })
    for _, res in pairs(results or {}) do
        pcall(showWindow, 'Phpactor Status', 'markdown', res['result'])
    end
end

function LspPhpactorBlackfireStart()
    local _, _ = vim.lsp.buf_request_sync(0, "blackfire/start", {})
end

function LspPhpactorBlackfireFinish()
    local _, _ = vim.lsp.buf_request_sync(0, "blackfire/finish", {})
end

vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(vim.lsp.status(), "info", {
            id = "lsp_progress",
            title = "LSP Progress",
            opts = function(notif)
                notif.icon = ev.data.params.value.kind == "end" and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
})
