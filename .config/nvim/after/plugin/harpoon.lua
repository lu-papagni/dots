local ui = require('harpoon.ui')
local mark = require('harpoon.mark')

vim.keymap.set('n', '<leader>hm', ui.toggle_quick_menu, {})
vim.keymap.set('n', '<leader>h', mark.add_file, {})
