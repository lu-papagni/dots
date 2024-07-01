-- Impostazione del tema
local Colorscheme = require("user.macro.colorscheme")

---@type ThemeSettings
local theme_settings = {
  color = "gruvbox-material",
  transparent = false,
  background = 'mix',
  foreground = 'mix',
  mode = 'dark'
}

require("user.keymaps")
require("user.lazy")
require("user.options")
require("user.snippets")

Colorscheme.apply(theme_settings)
