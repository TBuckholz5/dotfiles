return {
  dir = vim.fn.stdpath 'config' .. '/lua/jjnvim',
  enabled = false,
  name = 'jjnvim',
  lazy = true,
  cmd = 'JJLog',
  keys = {
    { '<leader>jn', '<cmd>JJLog<cr>', desc = 'jj log (native)' },
  },
  config = function()
    require('jjnvim').setup()
  end,
}
