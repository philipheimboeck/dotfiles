return {
    'mfussenegger/nvim-dap',
    dependencies = {
        -- Creates a beautiful debugger UI
        'rcarriga/nvim-dap-ui',

        -- Required dependency for nvim-dap-ui
        'nvim-neotest/nvim-nio',

        -- For virtual text
        'theHamsta/nvim-dap-virtual-text',

        -- Installs the debug adapters for you
        'williamboman/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim',
    },
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'

        require('mason-nvim-dap').setup({
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_installation = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = {
                -- Update this to ensure that you have the debuggers for the langs you want
                'delve',
            },
        })

        dapui.setup()

        -- Basic debugging keymaps, feel free to change to your liking!
        vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
        vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
        vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
        vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
        vim.keymap.set('n', '<F6>', dap.terminate, { desc = 'Debug: Stop' })
        vim.keymap.set('n', '<F9>', dap.run_to_cursor, { desc = 'Debug: Run to cursor' })
        vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
        vim.keymap.set('n', '<leader>B', function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end, { desc = 'Debug: Set Breakpoint' })

        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        -- PHP
        local xdebug_port = os.getenv('NVIM_XDEBUG_PORT') or 9003
        local xdebug_path_server = os.getenv('NVIM_XDEBUG_PATH_SERVER')
        local xdebug_path_local = os.getenv('NVIM_XDEBUG_PATH_LOCAL') or '${workspaceFolder}'

        dap.adapters.php = {
            type = 'executable',
            command = 'node',
            args = { vim.fn.stdpath('data') .. '/mason/packages/php-debug-adapter/extension/out/phpDebug.js' },
        }

        dap.configurations.php = {
            {
                type = 'php',
                request = 'launch',
                name = 'Listen for Xdebug docker: ' .. xdebug_path_local .. ':' .. (xdebug_path_server or 'unset'),
                port = xdebug_port,
                pathMappings = xdebug_path_local and xdebug_path_server
                    and {
                        [xdebug_path_server] = xdebug_path_local,
                    }
                    or nil,
            },
            {
                name = "listen for Xdebug local",
                type = "php",
                request = "launch",
                port = xdebug_port,
            },
        }
    end,
}
