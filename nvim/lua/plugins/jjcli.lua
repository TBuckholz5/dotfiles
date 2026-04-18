return {
  'nicolasgb/jj.nvim',
  version = '*',
  config = function()
    require('jj').setup {}
  end,
  keys = {
    { '<leader>js', '<cmd>J log<cr>', desc = '[J]j [S]tatus' },
    { '<leader>jb', '<cmd>J annotate<cr>', desc = '[J]j [A]nnotate' },
  },
}
