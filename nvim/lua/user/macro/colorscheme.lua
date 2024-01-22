local DEFAULT_THEME = "gruvbox-material"
local _current = nil
local _foreground = nil
local _background = nil

local function ApplyTheme(color, front, back)
  color = color or _current or DEFAULT_THEME

  if color == "gruvbox-material" then
    vim.g.gruvbox_material_background = back or 'medium'
    vim.g.gruvbox_material_foreground = front or 'material'
  end

  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  -- vim.api.nvim_set_hl(0, '@lsp.type.namespace', { italic=true })
  -- vim.api.nvim_set_hl(0, '@lsp.type.parameter', { italic=true })
  -- vim.api.nvim_set_hl(0, '@lsp.type.typeParameter', { link='@property' })
end

local function EditTextObjects(color)
  color = color or _current or DEFAULT_THEME
  if color == "gruvbox-material" then
    vim.api.nvim_set_hl(0, "TSPunctBracket", { link="Grey" })
  end
end

return {
  theme = {
    current = _current,
    foreground = _foreground,
    background = _background,
    apply = ApplyTheme,
  },
  utils = {
    editTextObjects = EditTextObjects
  }
}
