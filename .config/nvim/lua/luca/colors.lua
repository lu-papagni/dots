function Theme(color, front, back)
  local default_color = "gruvbox-material"
	color = color or default_color

  if color == "gruvbox-material" then
    vim.g.gruvbox_material_background = back or 'medium'
    vim.g.gruvbox_material_foreground = front or 'material'
  end

	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, '@lsp.type.namespace', { italic=true })
  vim.api.nvim_set_hl(0, '@lsp.type.parameter', { italic=true })
  vim.api.nvim_set_hl(0, '@lsp.type.typeParameter', { link='@property' })
end
