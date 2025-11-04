return {

  'akinsho/toggleterm.nvim',
  lazy = false,

  config = function()
    require('toggleterm').setup {}
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new { cmd = 'lazygit', hidden = true, close_on_exit = true, direction = 'float' }

    function _lazygit_toggle()
      lazygit:toggle()
    end
    vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>lua _lazygit_toggle()<CR>', { noremap = true, silent = true })

    local lazyjj = Terminal:new { cmd = 'lazyjj', hidden = true, close_on_exit = true, direction = 'float' }

    function _lazyjj_toggle()
      lazyjj:toggle()
    end
    vim.api.nvim_set_keymap('n', '<leader>jj', '<cmd>lua _lazyjj_toggle()<CR>', { noremap = true, silent = true })
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
