return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      ignore_focus = {
        "dapui_watches", "dapui_breakpoints",
        "dapui_scopes", "dapui_console",
        "dapui_stacks", "dap-repl"
      },
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = {
        {
          'mode',
          icons_enabled = true,
          icon = '',
        }
      },
      lualine_b = {
        {
          'branch',
          icons_enabled = true,
          icon = '',
        },
        {
          'diff',
          icons_enabled = true,
          icon = ' ',
        },
        'diagnostics'
      },
      lualine_c = {},
      lualine_x = {
        {
          'filetype',
          icon_only = true,
          padding = { left = 1 },
          separator = '',
        },
        {
          'filename',
          newfile_status = false,
          padding = { right = 1 },
          symbols = {
            modified = '',
            readonly = '',
          },
        },
        'encoding',
        {
          'fileformat',
          icons_enabled = true,
          symbols = {
            unix = 'LF',
            dos = 'CRLF',
            mac = 'CR',
          },
        },
      },
      lualine_y = { 'progress' },
      lualine_z = {
        {
          'location',
          icons_enabled = true,
          icon = { '󰵉', align = 'right' },
        },
      },
    }
  }
}
