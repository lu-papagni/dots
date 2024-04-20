return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        require("neodev").setup({})

        local lspconfig = require("lspconfig")
        local cmp_lsp = require("cmp_nvim_lsp")

        local on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true }
            opts.buffer = bufnr

            -- Keybinds
            opts.desc = "Show LSP references"
            vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

            opts.desc = "Go to declaration"
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

            opts.desc = "Show LSP definitions"
            vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

            opts.desc = "Show documentation under cursor"
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

            opts.desc = "Code actions"
            vim.keymap.set({ 'n', 'v' }, "<leader>ca", vim.lsp.buf.code_action, opts)

            opts.desc = "Smart rename"
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end

        local server_configs = {
            html = {},
            tsserver = {},
            lua_ls = {},
            clangd = {},
            pyright = {}
        }

        for server_name, opts in pairs(server_configs) do
            local boilerplate = {
                capabilities = cmp_lsp.default_capabilities(),
                on_attach = on_attach
            }
            table.insert(boilerplate, opts)
            lspconfig[server_name].setup(boilerplate)
        end
    end
}
