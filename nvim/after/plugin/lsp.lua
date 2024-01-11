local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.ensure_installed({
  'tsserver',
  'clangd',
  'jdtls',
  'html',
  'pyright',
})

lsp.setup()

-- Autocompletamento
local cmp = require('cmp')

cmp.setup {
  mapping = {
    ['<Tab>'] = cmp.mapping.confirm({select = true})
  }
}
