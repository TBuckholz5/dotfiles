return {
  'akinsho/toggleterm.nvim',
  config = function()
    require('toggleterm').setup {}
  end,
  keys = {
    { '<leader>tt', ':ToggleTerm direction=float<CR>', desc = '[T]oggle [T]erminal' },
  },
}
