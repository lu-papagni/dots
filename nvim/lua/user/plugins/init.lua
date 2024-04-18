return {
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  { 'j-hui/fidget.nvim', opts = {} },
  {
    "fladson/vim-kitty",
    ft = "kitty"
  },
  { 'folke/neodev.nvim', lazy = true },
}
