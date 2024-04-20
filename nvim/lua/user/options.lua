-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable relative numbers
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
-- vim.o.updatetime = 250
-- vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Disabilita la visualizzazione della modalità
vim.o.showmode = false

-- Disabilita la barra delle informazioni (ruler)
vim.o.ruler = false

-- Imposta laststatus su 0
vim.o.laststatus = 0

-- 4 spazi di tabulazione
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Disabilita continuazione commenti quando premo O
vim.api.nvim_create_autocmd('FileType', {
  pattern = { '*' },
  callback = function()
    vim.cmd("set formatoptions-=o")
  end
})

-- Disabilita wrapping
vim.o.wrap = false
