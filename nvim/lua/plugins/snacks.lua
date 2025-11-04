return {
  'folke/snacks.nvim',
  config = function(_, opts)
    require('snacks').setup(opts)
  end,
  ---@type snacks.Config
  opts = {
    lazygit = {},
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
      '<leader>tt',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle Terminal',
      mode = { 'n', 't' },
    },
    {
      '<leader>gp',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },

    -- Picker.
    -- {
    --   '<leader>sr',
    --   function()
    --     Snacks.picker.resume()
    --   end,
    --   desc = 'Resume',
    -- },
    -- {
    --   '<leader>sf',
    --   function()
    --     Snacks.picker.files()
    --   end,
    --   desc = 'Search Files',
    -- },
    -- {
    --   '<leader>/',
    --   function()
    --     Snacks.picker.lines()
    --   end,
    --   desc = 'Buffer Lines',
    -- },
    -- {
    --   '<leader>s/',
    --   function()
    --     Snacks.picker.grep()
    --   end,
    --   desc = 'Grep',
    -- },
    -- {
    --   '<leader>sw',
    --   function()
    --     Snacks.picker.grep_word()
    --   end,
    --   desc = 'Visual selection or word',
    --   mode = { 'n', 'x' },
    -- },
    -- {
    --   '<leader>sk',
    --   function()
    --     Snacks.picker.keymaps()
    --   end,
    --   desc = 'Keymaps',
    -- },
    -- {
    --   '<leader>su',
    --   function()
    --     Snacks.picker.undo()
    --   end,
    --   desc = 'Undo History',
    -- },
    -- {
    --   '<leader>sb',
    --   function()
    --     Snacks.picker.buffers()
    --   end,
    --   desc = 'Buffers',
    -- },
    -- {
    --   '<leader>sd',
    --   function()
    --     Snacks.picker.diagnostics()
    --   end,
    --   desc = 'Diagnostics',
    -- },
    -- Other.
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
