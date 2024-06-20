return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")
        local mason = require("user.macro.mason-ensure")

        conform.setup({
            formatters_by_ft = {
                c = { "clang_format" },
                cpp = { "clang_format" }
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 500
            }
        })

        conform.formatters.clang_format = {
            args = { "-style=file" }
        }

        -- Installazione automatica formatters
        mason.ensure({ "clang-format" })
    end,

}
