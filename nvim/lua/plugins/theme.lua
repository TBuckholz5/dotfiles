return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'Shatur/neovim-ayu',
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    vim.o.background = 'dark'

    vim.cmd [[colorscheme ayu]]
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#45474a', bold = true })
  end,
}
