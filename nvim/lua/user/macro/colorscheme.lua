local DEFAULT_THEME = "gruvbox-material"

local M = {}
M.current = nil
M.foreground = nil
M.background = nil
M.transparent = false

--- Applica il tema scelto a nvim
---@param color string|nil Nome del tema
---@param front string Variante dei colori per il testo
---@param back string Variante dei colori per lo sfondo
local function ApplyTheme(color, front, back)
  color = (color or M.current) or DEFAULT_THEME

  if color == "gruvbox-material" then
    vim.g.gruvbox_material_background = back or 'medium'
    vim.g.gruvbox_material_foreground = front or 'material'
  end

  vim.cmd.colorscheme(color)
  if M.transparent then
    local highlightGroups = {
      "Normal",
      "NormalNC",
      "NonText",
      "EndOfBuffer",
    }
    for i, group in ipairs(highlightGroups) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
  end

  M.current = color
end
M.apply = ApplyTheme

local function EditTextObjects(color)
  color = (color or M.current) or DEFAULT_THEME
  if color == "gruvbox-material" then
    vim.api.nvim_set_hl(0, "TSPunctBracket", { link = "Grey" })
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "Grey" })
  end
end
M.editTextObjects = EditTextObjects

return M
