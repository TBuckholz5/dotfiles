return {
  'akinsho/toggleterm.nvim',
  config = function()
    require('toggleterm').setup {}
  end,
  keys = {
    {
      '<leader>tt',
      function()
        require('toggleterm').toggle(nil, nil, nil, 'float', nil)
      end,
      mode = { 'n', 't' },
      desc = '[T]oggle [T]erminal',
    },
  },
}
