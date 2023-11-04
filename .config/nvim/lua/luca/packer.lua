-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Temi
	use({ 'rose-pine/neovim', as = 'rose-pine' })  -- Rose Piné
  use({ "rebelot/kanagawa.nvim", as = 'kanagawa' }) -- Kanagawa
  use({ "catppuccin/nvim", as = "catppuccin" }) -- Catppuccin
  use({ 'almo7aya/neogruvbox.nvim', as = 'neogruv' }) -- NeoGruvbox
  use({ "neanias/everforest-nvim", as = 'everforest' }) -- Everforest
  use({ "justinsgithub/oh-my-monokai.nvim", as = 'omonokai' }) -- Oh My Monokai
  use({ 'marko-cerovac/material.nvim', as = 'material'}) -- Material
  use({ 'sainnhe/gruvbox-material', as = 'gruv-material'}) -- Gruvbox Material
  use({ "cpea2506/one_monokai.nvim", as = 'one-monokai'}) -- One Monokai

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.2',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use{ 'hiphish/rainbow-delimiters.nvim' }
	use {
	'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{'williamboman/mason.nvim'},           -- Optional
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},     -- Required
			{'hrsh7th/cmp-nvim-lsp'}, -- Required
			{'L3MON4D3/LuaSnip'},     -- Required
		}
	}

	-- Completamento automatico parentesi
	use {
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	}

	-- Status line
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}

  -- Harpoon by ThePrimeagen
  use('ThePrimeagen/harpoon')
end)
