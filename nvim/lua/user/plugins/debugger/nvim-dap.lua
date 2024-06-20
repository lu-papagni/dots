return {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
        local mason = require("user.macro.mason-ensure")
        local dap = require("dap")

        mason.ensure({
            "codelldb",
        })

        dap.adapters.codelldb = {
            type = 'server',
            port = '${port}',
            executable = {
                command = vim.fn.exepath('codelldb'),
                args = { '--port', '${port}' },
            },
        }

        dap.configurations.c = {
            {
                name = 'LLDB: Launch',
                type = 'codelldb',
                request = 'launch',
                program = '${workspaceFolder}/${fileBasenameNoExtension}',
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
                console = 'integratedTerminal',
            }
        }

        dap.configurations.cpp = dap.configurations.c
    end
}
