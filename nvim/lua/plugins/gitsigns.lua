local function is_jj_repo()
  return vim.fn.finddir('.jj', vim.fn.getcwd() .. ';') ~= ''
end

return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  lazy = false,
  cond = function() return not is_jj_repo() end,
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
  keys = {
    { '<leader>gb', '<cmd>Gitsigns blame<cr>', desc = '[G]it [B]lame' },
  },
}
