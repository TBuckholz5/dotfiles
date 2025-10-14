return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    lazygit = {},
  },
  keys = {
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>gg',
      function()
        require('snacks').lazygit.open()
      end,
      desc = 'LazyGit',
    },
  },
}
