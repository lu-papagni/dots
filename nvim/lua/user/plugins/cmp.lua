return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets"
  },
  config = function()
      local cmp = require("cmp")
      local snip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
          completion = {
              completeopt = "menu,menuone,preview,noselect"
          },
          snippet = {
              expand = function(args)
                  snip.lsp_expand(args.body)
              end
          },
          mapping = cmp.mapping.preset.insert({
              ["<C-k>"] = cmp.mapping.select_prev_item(),   -- Previous suggestion
              ["<C-j>"] = cmp.mapping.select_next_item(),   -- Next suggestion
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),      -- Next suggestion
              ["<C-f>"] = cmp.mapping.scroll_docs(4),       -- Next suggestion
              ["<C-Space>"] = cmp.mapping.complete(),       -- Show completion suggestions
              ["<C-e>"] = cmp.mapping.abort(),       -- Close completion menu
              ["<Tab>"] = cmp.mapping.confirm({ select=true })
          }),
          -- Sources for autocompletion
          sources = cmp.config.sources({
              { name = "nvim_lsp" },    -- LSP suggestions
              { name = "luasnip" },     -- Snippets
              { name = "buffer" },      -- Suggest text in current file
              { name = "path" },        -- Directiories
          })
      })
  end
}
