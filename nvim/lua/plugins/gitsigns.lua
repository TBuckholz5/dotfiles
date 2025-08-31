return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  lazy = false,
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
  keys = {
    { '<leader>gb', '<cmd>Gitsigns blame<cr>', desc = '[G]it [B]lame' },
  },
}
