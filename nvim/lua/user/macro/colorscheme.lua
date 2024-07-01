local DEFAULT_THEME = "gruvbox-material"

---@class ThemeSettings
--- Insieme di impostazioni per l'applicazione di un tema
local DEFAULT_SETTINGS = {
  color = DEFAULT_THEME, ---@type string
  foreground = nil, ---@type string|nil
  background = nil, ---@type string|nil
  transparent = true, ---@type boolean
  mode = 'dark', ---@type 'light'|'dark'|nil
}

local M = {}
M.current = nil
M.mode = nil

--- Modifica gli highlight groups relativi a TreeSitter
---@param theme string|nil Nome del tema
local function EditTextObjects(theme)
  theme = (theme or M.current) or DEFAULT_THEME
  if theme == "gruvbox-material" then
    vim.api.nvim_set_hl(0, "TSPunctBracket", { link = "Grey" })
    --vim.api.nvim_set_hl(0, "FloatBorder", { link = "Grey" })
  end
end

--- Rende il tema trasparente
local function ToggleTransparency()
  if M.current == 'gruvbox-material' then
    vim.g.gruvbox_material_transparent_background = not vim.g.gruvbox_material_transparent_background
  else
    local highlightGroups = {
      "Normal",
      "NormalFloat",
      "NormalNC",
      "NonText",
      "EndOfBuffer",
    }
    for _, group in ipairs(highlightGroups) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
  end

  vim.cmd.colorscheme(M.current)
end

local function ToggleMode()
  if M.mode == 'dark' then
    M.mode = 'light'
  else
    M.mode = 'dark'
  end

  vim.o.background = M.mode
  EditTextObjects(M.current)
end

--- Applica il tema scelto a nvim
---@param settings ThemeSettings
local function ApplyTheme(settings)
  settings = settings or DEFAULT_SETTINGS
  local theme = settings.color or DEFAULT_THEME

  vim.o.background = settings.mode or 'dark'
  M.current = theme
  M.mode = settings.mode

  if theme == "gruvbox-material" then
    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_material_background = settings.background or 'medium'
    vim.g.gruvbox_material_foreground = settings.foreground or 'material'
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_show_eob = 0
    vim.g.gruvbox_material_float_style = 'bright'
    vim.g.gruvbox_material_diagnostic_text_highlight = 1

    if settings.transparent then ToggleTransparency() end
  end

  vim.cmd.colorscheme(theme)
end

M.apply = ApplyTheme
M.editTextObjects = EditTextObjects
M.toggleMode = ToggleMode
M.toggleTransparency = ToggleTransparency

return M
