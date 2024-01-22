require("user.vim-options")
require("user.vim-keymaps")
local Colorscheme = require("user.macro.colorscheme")
Colorscheme.theme.current = "gruvbox-material"

require("user.lazy")

Colorscheme.theme.apply()
