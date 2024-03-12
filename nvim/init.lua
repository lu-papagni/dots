require("user.options")
require("user.keymaps")

-- Impostazione del tema
local Colorscheme = require("user.macro.colorscheme")
Colorscheme.current = "gruvbox-material"
Colorscheme.transparent = true

require("user.lazy")

Colorscheme.apply(nil, 'mix')
