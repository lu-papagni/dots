function Theme(color, back, front)
  local default_color = "rose-pine"
	color = color or default_color

  if color == "material" then
    vim.g.material_style = variant or "darker"
  elseif color == "gruvbox-material" then
    vim.g.gruvbox_material_background = back or 'medium'
    vim.g.gruvbox_material_foreground = front or 'material'
  elseif color == "neogruvbox" then
    require('lualine').setup {
      options = { theme = 'gruvbox' }
    }
  elseif color == "one_monokai" then
    require("one_monokai").setup({
      transparent = true,
    })
  end

	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, '@lsp.type.namespace', { italic=true })
  vim.api.nvim_set_hl(0, '@lsp.type.parameter', { italic=true })
  vim.api.nvim_set_hl(0, '@lsp.type.typeParameter', { link='@property' })
end

Theme('gruvbox-material', 'hard', 'mix')
