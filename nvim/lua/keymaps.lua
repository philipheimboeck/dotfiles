vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })

vim.g.mapleader = " "

-- define common options
local opts = {
    noremap = true, -- non-recursive
    silent = true,  -- do not show message
}

-- Hint: see `:h vim.map.set()`
-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { unpack(opts), desc = 'Window left' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { unpack(opts), desc = 'Window down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { unpack(opts), desc = 'Window up' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { unpack(opts), desc = 'Window left' })

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)


-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)
