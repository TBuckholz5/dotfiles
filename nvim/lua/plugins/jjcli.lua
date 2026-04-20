return {
  'nicolasgb/jj.nvim',
  version = '*',
  lazy = false,
  config = function()
    require('jj').setup {
      terminal = {
        window = {
          type = 'hsplit',
        },
      },
    }
  end,
  keys = {
    { '<leader>js', '<cmd>J log<cr>', desc = '[J]j [S]tatus' },
    { '<leader>jb', '<cmd>J annotate<cr>', desc = '[J]j [A]nnotate' },
  },
}
