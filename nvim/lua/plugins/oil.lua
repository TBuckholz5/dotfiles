return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  config = function()
    require('oil').setup {
      keymaps = {
        ['<Esc>'] = 'actions.parent',
      },
    }
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  keys = {
    {
      '-',
      function()
        require('oil').open()
        -- Wait for oil buffer to load before opening preview
        vim.wait(1000, function()
          return require('oil').get_cursor_entry() ~= nil
        end)
        if require('oil').get_cursor_entry() then
          require('oil').open_preview()
        end
      end,
      desc = 'Open parent directory in Oil',
    },
  },
}
