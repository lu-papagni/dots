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

        local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or 'rounded'
            opts.max_width = 80
            return orig_util_open_floating_preview(contents, syntax, opts, ...)
        end

        local on_attach = function(client, bufnr)
            local opts = {
                noremap = true,
                silent = true,
                buffer = bufnr
            }

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

            -- Suggerimenti contestuali
            if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                vim.keymap.set('n', '<leader>th', function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end)
            end
        end            -- on_attach

        --[[ SERVER ]] --
        lspconfig.html.setup {
            capabilities = cmp_lsp.default_capabilities(),
            on_attach = on_attach
        }

        lspconfig.clangd.setup {
            capabilities = cmp_lsp.default_capabilities(),
            on_attach = on_attach
        }

        lspconfig.pyright.setup {
            capabilities = cmp_lsp.default_capabilities(),
            on_attach = on_attach
        }

        lspconfig.lua_ls.setup {
            capabilities = cmp_lsp.default_capabilities(),
            on_attach = on_attach,
            settings = {
                Lua = {
                    telemetry = { enable = false },
                    hint = { enable = true },
                }
            }
        }

        lspconfig.tsserver.setup {
            capabilities = cmp_lsp.default_capabilities(),
            on_attach = on_attach,
            init_options = {
                preferences = {
                    tsserincludeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                }
            }
        }
    end
}
