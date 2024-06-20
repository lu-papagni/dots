-- Tasto leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- QOL word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostica
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Vai a prec. messaggio di diagnostica' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Vai a succ. messaggio di diagnostica' })
vim.keymap.set('n', '<leader>dm', vim.diagnostic.open_float, { desc = 'Apri menu diagnostica' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Apri lista diagnostica' })

-- Apri esplora file (netrw)
vim.keymap.set('n', '<leader>e', vim.cmd.Ex)

-- Chiudi buffer corrente
vim.keymap.set('n', "<leader>q", "<cmd>bd<cr>", { desc = "Chiudi buffer corrente" })

-- Formatta intero file in modalità NORMAL o selezione in modalità VISUAL
vim.keymap.set({ "n", "v" }, "<leader>fo", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500
  })
end)
