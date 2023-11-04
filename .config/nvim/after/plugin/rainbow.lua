local rainbow_delimiters = require 'rainbow-delimiters'

vim.g.rainbow_delimiters = {
  strategy = {
    [''] = rainbow_delimiters.strategy['global'],
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
  },
  highlight = {
    'White',
    'White',
    'RainbowDelimiterYellow',
    'RainbowDelimiterGreen',
    'Aqua',
  },
}
