return {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    cmd = { "Mason", "MasonInstall" },
    event = { "BufReadPre", "VeryLazy" },
    config = function()
        local mason = require("mason")
        local lspconfig = require("mason-lspconfig")

        mason.setup({
            ui = {
                border = "rounded",
            }
        })

        lspconfig.setup({
            ensure_installed = {
                "tsserver", -- JavaScript & TypeScript
                "html",
                "lua_ls",
                "pyright", -- Python
                "clangd",  -- C/C++
            },
            automatic_installation = true,
        })
    end
}
