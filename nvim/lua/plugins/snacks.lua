return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,

  opts = {
    terminal = {
      enabled = true,
      win = {
        style = 'terminal',
        position = 'float',
        relative = 'editor',
        border = 'rounded',
      },
    },
    lazygit = { enabled = true },
  },

  keys = {
    {
      '<leader>tt',
      function()
        Snacks.terminal.toggle()
      end,
      mode = { 'n', 't' },
      desc = '[T]oggle [T]erminal',
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>jj',
      function()
        Snacks.terminal.toggle 'jjui'
      end,
      mode = { 'n' },
      desc = 'jjui',
    },
  },
}
