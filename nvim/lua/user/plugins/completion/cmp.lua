return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "onsails/lspkind.nvim",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            formatting = {
                expandable_indicator = true,
                fields = { 'abbr', 'kind', 'menu' },
                format = lspkind.cmp_format({
                    with_text = true,
                    maxwidth = 50,
                    before = function(_, vim_item)
                        local m = vim_item.menu and vim_item.menu or ""
                        if #m > 20 then
                            vim_item.menu = string.sub(m, 1, 20) .. "..."
                        end
                        return vim_item
                    end,
                })
            },
            completion = {
                completeopt = "menu,menuone,preview,select"
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(), -- Suggerimento precedente
                ["<C-j>"] = cmp.mapping.select_next_item(), -- Suggerimento successivo
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),    -- Show completion suggestions
                ["<C-e>"] = cmp.mapping.abort(),           -- Close completion menu
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback) -- Parametro successivo
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback) -- Parametro precedente
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            -- Sources for autocompletion
            sources = cmp.config.sources({
                { name = "nvim_lsp" }, -- LSP suggestions
                { name = "luasnip" },  -- Snippets
                -- { name = "buffer" },   -- Suggest text in current file
                { name = "path" },     -- Directiories
            }),
            window = {
                completion = {
                    border = "rounded",
                    winhighlight = "Normal:CmpPmenu,FloatBorder:Grey,CursorLine:PmenuSel,Search:None"
                },
                documentation = {
                    border = "rounded",
                    winhighlight = "Normal:CmpPmenu,FloatBorder:Grey,CursorLine:PmenuSel,Search:None"
                },
            }
        })
    end
}
