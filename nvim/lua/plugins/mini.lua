return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    require('mini.diff').setup()
    require('mini.jump2d').setup {
      mappings = {
        start_jumping = '<leader>f',
      },
    }
    require('mini.jump').setup()
    require('mini.notify').setup()
    require('mini.files').setup {
      mappings = {
        go_in = '<CR>',
        go_out = '<Esc>',
      },
      windows = {
        preview = true,
        width_preview = 70,
      },
    }
    vim.keymap.set('n', '-', function()
      local MiniFiles = require 'mini.files'
      local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      vim.schedule(function()
        MiniFiles.reveal_cwd()
      end)
    end, { desc = 'Open [E]xplorer' })
    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
