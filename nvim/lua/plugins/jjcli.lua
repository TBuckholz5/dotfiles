return {
  'NicholasZolton/neojj',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',

    'sindrets/diffview.nvim',

    'ibhagwan/fzf-lua',
  },
  cmd = 'Neojj',
  keys = {
    { '<leader>jl', '<cmd>Neojj<cr>', desc = 'Show Neojj UI' },
  },
}
