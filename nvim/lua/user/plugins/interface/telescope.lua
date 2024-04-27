return {
  'nvim-telescope/telescope.nvim',
  event = "UIEnter",
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
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-p>"] = false,
            ["<C-n>"] = false,
          }
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        }
      }

    })

    telescope.load_extension("fzf")

    local builtin = require("telescope.builtin")
    -- Telescope shortcuts
    vim.keymap.set('n', "<leader>ff", builtin.find_files)
    vim.keymap.set('n', "<leader>fd", builtin.live_grep)
    vim.keymap.set('n', "<leader>fu", builtin.grep_string)
    vim.keymap.set('n', "<leader>fs", function()
      builtin.current_buffer_fuzzy_find(
        require("telescope.themes").get_dropdown({
          previewer = false,
        })
      )
    end
    )
    vim.keymap.set('n', "<leader>:", builtin.command_history)
    vim.keymap.set('n', "<leader><leader>", builtin.buffers)
  end
}
