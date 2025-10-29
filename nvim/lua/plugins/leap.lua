return {
  'ggandor/leap.nvim',
  lazy = false,
  config = function(_, opts)
    require('leap').setup(opts)
    vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
    vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
  end,
}
