return {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
        "mfussenegger/nvim-dap",
    },
    config = function()
        local dap = require("dap")
        local dap_ui = require("dapui")

        dap_ui.setup()

        dap.listeners.after.event_initialized["dapui_config"] = function()
            dap_ui.open()
        end
        dap.listeners.before.event_initialized["dapui_config"] = function()
            dap_ui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dap_ui.close()
        end
    end
}
