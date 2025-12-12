return {
  'folke/snacks.nvim',
  config = function(_, opts)
    require('snacks').setup(opts)
  end,
  ---@type snacks.Config
  opts = {
    notifier = {},
    gh = {},
    picker = {
      sources = {
        gh_pr = {},
      },
    },
    terminal = {
      win = {
        style = 'float',
      },
    },
  },
  keys = {
    {
      '<leader>gp',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },

    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
  },
}
