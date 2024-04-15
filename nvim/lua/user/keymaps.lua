vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Open file explorer
vim.keymap.set('n', '<leader>ex', vim.cmd.Ex)

-- Format entire file in NORMAL mode or current selection in VISUAL mode
vim.keymap.set({ "n", "v" }, "<leader>fo", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500
  })
end)

-- Telescope shortcuts
vim.keymap.set('n', "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find file in working directory" })
vim.keymap.set('n', "<leader>fd", "<cmd>Telescope live_grep<cr>", { desc = "Find string in working directory" })
vim.keymap.set('n', "<leader>fu", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor" })
vim.keymap.set('n', "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>",
  { desc = "Find string in open buffers" })

-- Toggle breakpoint
vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>")

-- Run debugger
vim.keymap.set("n", "<leader>dr", "<cmd>DapContinue<CR>")

-- Generate documentation
vim.keymap.set('n', '<leader>doc', '<cmd>Neogen<CR>')
