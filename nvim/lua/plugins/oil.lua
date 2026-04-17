return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  config = function()
    require('oil').setup {
      keymaps = {
        ['<C-l>'] = 'actions.select',
        ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-x>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-y>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-m>'] = 'actions.refresh',
        ['<C-h>'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
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
