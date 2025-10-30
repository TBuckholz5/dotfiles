return {
  'nicolasgb/jj.nvim',
  config = function()
    require('jj').setup {}
    local cmd = require 'jj.cmd'
    vim.keymap.set('n', '<leader>jj', cmd.status, { desc = 'JJ: Show status' })
  end,
}
