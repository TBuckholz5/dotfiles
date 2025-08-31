return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    lazygit = {},
    scratch = {},
  },
  keys = {
    {
      '<leader>gg',
      function()
        require('snacks').lazygit.open()
      end,
      desc = 'LazyGit',
    },
    {
      '<leader>ff',
      function()
        require('snacks').scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>fl',
      function()
        require('snacks').scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
  },
}
