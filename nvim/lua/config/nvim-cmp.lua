local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local php_namespace = require("../namespace")
local cmp = require("cmp")
local lspkind = require("lspkind")
local snippets_by_filetype = {
    php = {
        {
            trigger = 'php',
            body = '<?php\n\nnamespace ${NAMESPACE};\n\n${1|class,interface,enum|} ${TM_FILENAME_BASE}\n{\n$0\n}',
            --- @param body string
            substitute = function(body)
                return body:gsub("${NAMESPACE}", php_namespace.generate_namespace() or '')
            end
        },
        {
            trigger = 'ctr',
            body = 'public function __construct() {}'
        },
        {
            trigger = 'fun',
            body = '${1|public,private,protected|} function ${2:name}($3): ${4:void}\n{$0\n}',
        }
    }
}

local snippets_buffer_cache = {}
cmp.register_source('snippets', {
    complete = function(_, _, callback)
        local bufnr = vim.api.nvim_get_current_buf()

        if not snippets_buffer_cache[bufnr] then
            local filetype = vim.bo.filetype

            snippets_buffer_cache[bufnr] = snippets_by_filetype[filetype]
                and vim.tbl_map(function(snippet)
                    local text = snippet.body
                    if snippet['substitute'] ~= nil and type(snippet.substitute) == "function" then
                        text = snippet.substitute(text)
                    end

                    return {
                        word = snippet.trigger,
                        label = snippet.trigger,
                        kind = vim.lsp.protocol.CompletionItemKind.Snippet,
                        insertText = text,
                        insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
                    }
                end, snippets_by_filetype[filetype])
                or nil
        end

        callback(snippets_buffer_cache[bufnr])
    end
})

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        -- Use <C-b/f> to scroll the docs
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- Use <C-k/j> to switch in items
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        -- Use <CR>(Enter) to confirm selection
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = true }),

        -- A super tab
        ["<Tab>"] = cmp.mapping(function(fallback)
            -- Hint: if the completion menu is visible select next one
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.snippet.active({ direction = 1 }) then
                vim.snippet.jump(1)
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }), -- i - insert mode; s - select mode
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.snippet.active({ direction = -1 }) then
                vim.snippet.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

        -- Ollama
        --['<C-x>'] = cmp.mapping(
        --    cmp.mapping.complete({
        --        config = {
        --            sources = cmp.config.sources({
        --                { name = 'cmp_ai' },
        --            }),
        --        },
        --    }),
        --    { 'i' }
        --),
    }),

    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 50,        -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- can also be a function to dynamically calculate max width such as
            -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
            ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default
        }),
    },

    -- Set source precedence
    sources = cmp.config.sources({
        -- { name = 'cmp_ai' },   -- For local AI
        { name = 'nvim_lsp' }, -- For nvim-lsp
        { name = 'snippets' },
        { name = 'buffer' },   -- For buffer word completion
        { name = 'path' },     -- For path completion
    })
})
