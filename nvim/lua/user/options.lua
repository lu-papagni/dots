vim.opt.hlsearch = false -- Non evidenziare le parole durante la ricerca

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.mouse = 'a'               -- Attiva il mouse

vim.opt.clipboard = 'unnamedplus' -- La clipboard è sincronizzata con il sistema

vim.opt.breakindent = true        -- Le righe che escono dal bordo vengono mandate a capo e indentate

vim.opt.undofile = true           -- Salva cronologia annulla operazione

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.wo.signcolumn = 'yes' -- Attiva colonna dei numeri

vim.opt.completeopt = 'menuone,noselect'

vim.opt.termguicolors = true -- Supporto truecolor

vim.opt.showmode = false     -- Disabilita la visualizzazione della modalità

vim.opt.ruler = false        -- Disabilita la barra delle informazioni (ruler)

vim.opt.laststatus = 0       -- Imposta laststatus su 0

-- 4 spazi di tabulazione
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.wrap = false  -- Disabilita wrapping

vim.opt.scrolloff = 9 -- Numero minimo di linee sopra/sotto al cursore

-- Disabilita continuazione commenti quando premo O
vim.api.nvim_create_autocmd('FileType', {
  pattern = { '*' },
  callback = function()
    vim.cmd("set formatoptions-=o")
  end
})

-- Evidenzia brevemente il testo quando copio
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("my-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end
})

vim.api.nvim_create_user_command("ToggleThemeVariant", require("user.macro.colorscheme").toggleMode, {})
vim.api.nvim_create_user_command("ToggleThemeTransparency", require("user.macro.colorscheme").toggleTransparency, {})

-- Rimuovi il padding di kitty
if os.getenv('TERM') == 'xterm-kitty' then
  vim.system({ 'kitty', '@', 'set-spacing', 'padding=0' }, { detach = true })

  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
      vim.system({ 'kitty', '@', 'set-spacing', 'padding=default' }, { detach = true })
    end
  })
end

vim.g.c_syntax_for_h = true
