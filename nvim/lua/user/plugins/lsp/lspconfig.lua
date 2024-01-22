return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_lsp = require("cmp_nvim_lsp")

        local on_attach = function(client, bufnr)
            local opts = { noremap=true, silent=true }
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

        -- Used to enable autocompletion if passed to lsp server config
        local capabilities = cmp_lsp.default_capabilities()

        -- Server configuration
        -- HTML
        lspconfig["html"].setup({
            capabilities = capabilities,
            on_attach = on_attach
        })

        -- TypeScript & JavaScript
        lspconfig["tsserver"].setup({
            capabilities = capabilities,
            on_attach = on_attach
        })

        -- Lua
        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true
                        }
                    }
                }
            }
        })

        -- C/C++
        lspconfig["clangd"].setup({
            capabilities = capabilities,
            on_attach = on_attach
        })

        -- Python
        lspconfig["pyright"].setup({
            capabilities = capabilities,
            on_attach = on_attach
        })
    end
}
