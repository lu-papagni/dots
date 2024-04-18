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

-- Sostituisci parola
vim.keymap.set('n', "S", "viws", { desc = "Sostituisci parola" })

-- Formatta intero file in modalità NORMAL o selezione in modalità VISUAL
vim.keymap.set({ "n", "v" }, "<leader>fo", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500
  })
end)

-- Debugger keymaps
vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Attiva o disattiva breakpoint" })
vim.keymap.set("n", "<leader>dr", "<cmd>DapContinue<CR>", { desc = "Avvia debugger" })

-- Doxygen
vim.keymap.set('n', '<leader>doc', '<cmd>Neogen<CR>', { desc = "Genera commento doxygen" })
