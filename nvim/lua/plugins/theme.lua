return {
  'yonatanperel/lake-dweller.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('lake-dweller').setup {
      variant = 'ocean-dweller',
    }
    vim.cmd.colorscheme 'lake-dweller'
  end,
}
