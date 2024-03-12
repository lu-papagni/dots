return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  opts = {
    extensions = {
      fzf = {
        fuzzy = true,                         -- false will only do exact matching
        override_generic_sorter = true,       -- override the generic sorter
        override_file_sorter = true,          -- override the file sorter
        case_mode = "smart_case",             -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      }
    }
  },
  config = function()
    local telescope = require("telescope")

    telescope.load_extension("fzf")
  end
}
