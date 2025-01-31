local M = {}

--- @return string|nil
function M.generate_namespace()
    local composer_json = vim.fn.readfile(vim.fn.getcwd() .. "/composer.json")
    local composer_data = vim.fn.json_decode(table.concat(composer_json))

    -- Find PSR-4 namespaces
    local psr_4_namespaces = {}
    if composer_data.autoload and composer_data.autoload['psr-4'] then
        for namespace, path in pairs(composer_data.autoload['psr-4']) do
            table.insert(psr_4_namespaces, { namespace = namespace, path = path })
        end
    end
    if composer_data['autoload-dev'] and composer_data['autoload-dev']['psr-4'] then
        for namespace, path in pairs(composer_data['autoload-dev']['psr-4']) do
            table.insert(psr_4_namespaces, { namespace = namespace, path = path })
        end
    end

    -- Find matching namespace
    local current_path = vim.fn.fnamemodify(vim.fn.expand("%:~:."), ":h")
    local matching_namespace = nil
    for _, ns in ipairs(psr_4_namespaces) do
        local match = string.match(current_path, "^" .. ns.path .. "(.*)")
        if match then
            matching_namespace = ns.namespace .. match:gsub("^/", ""):gsub("/", "\\")
            break
        end
    end

    return matching_namespace
end

local function insert_namespace()
    vim.api.nvim_buf_set_lines(
        vim.api.nvim_get_current_buf(),
        3,
        3,
        false,
        { "namespace " .. (M.generate_namespace() or '') .. ";" }
    )
end

vim.keymap.set('n', '<leader>ns', insert_namespace, { desc = "Generate namespace" })

return M
