return {
  url = 'https://tangled.org/ronshavit.com/mini.diff.jj',
  name = 'mini.diff.jj',
  dependencies = { 'echasnovski/mini.nvim' },
  event = 'VeryLazy',
  config = function()
    require('mini.diff').setup {
      source = require 'mini.diff.jj',
      mappings = {
        goto_prev = '[c',
        goto_next = ']c',
        goto_first = '[C',
        goto_last = ']C',
      },
    }
  end,
}
