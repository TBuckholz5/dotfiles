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
    require('mini.jump2d').setup {}
    vim.keymap.set('n', 's', function()
      require('mini.jump2d').start()
    end, { desc = 'Jump2d' })
    require('mini.jump').setup {}
    require('mini.surround').setup {

      mappings = {
        add = 'gsa', -- Add surrounding in Normal and Visual modes
        delete = 'gsd', -- Delete surrounding
        find = 'gsf', -- Find surrounding (to the right)
        find_left = 'gsF', -- Find surrounding (to the left)
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsr', -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
      },
    }
    require('mini.diff').setup()
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
