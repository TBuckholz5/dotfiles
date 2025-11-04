return {
  'nicolasgb/jj.nvim',
  config = function()
    require('jj').setup {}
    local cmd = require 'jj.cmd'
    vim.keymap.set('n', '<leader>jj', cmd.status, { desc = 'JJ: Show status' })
    vim.keymap.set('n', '<leader>jl', cmd.log, { desc = 'JJ: Show log' })
    vim.keymap.set('n', '<leader>jb', '<cmd>J bookmark list<cr>', { desc = 'JJ: Show bookmarks' })
  end,
}
