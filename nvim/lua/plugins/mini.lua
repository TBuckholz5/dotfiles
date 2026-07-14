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
    require('mini.pairs').setup()

    local hipatterns = require 'mini.hipatterns'
    hipatterns.setup {
      highlighters = {
        fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack      = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
        todo      = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
        note      = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    }

    require('mini.icons').setup()
    MiniIcons.mock_nvim_web_devicons()

    require('mini.diff').setup()
    require('mini.files').setup {
      mappings = {
        close = '-',
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
    end, { desc = 'Open Explorer' })

    local clue = require 'mini.clue'
    clue.setup {
      window = { delay = 250 },
      triggers = {
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
      },
      clues = {
        clue.gen_clues.builtin_completion(),
        clue.gen_clues.g(),
        clue.gen_clues.marks(),
        clue.gen_clues.registers(),
        clue.gen_clues.windows(),
        clue.gen_clues.z(),
        { mode = 'n', keys = '<Leader>c', desc = 'Tab' },
        { mode = 'n', keys = '<Leader>d', desc = 'Diagnostics/Debug' },
        { mode = 'n', keys = '<Leader>f', desc = 'Search' },
        { mode = 'n', keys = '<Leader>g', desc = 'Git' },
        { mode = 'n', keys = '<Leader>l', desc = 'LSP' },
        { mode = 'n', keys = '<Leader>s', desc = 'Search' },
        { mode = 'n', keys = '<Leader>t', desc = 'Toggle' },
        { mode = 'n', keys = '<Leader>h', desc = 'Git Hunk' },
        { mode = 'x', keys = '<Leader>h', desc = 'Git Hunk' },
      },
    }

    local jj_branch_cache = ''
    local function update_jj_branch()
      vim.fn.jobstart({
        'jj', 'log', '--no-pager', '-r', '::@ & bookmarks()',
        '--no-graph', '-T', 'if(self.bookmarks(), self.bookmarks() ++ " ")', '-n', '1',
      }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          local result = table.concat(data or {}, ''):gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
          jj_branch_cache = result ~= '' and ('jj:' .. result) or ''
          vim.cmd 'redrawstatus'
        end,
        on_stderr = function() end,
        on_exit = function(_, code)
          if code ~= 0 then jj_branch_cache = '' end
        end,
      })
    end
    vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'DirChanged' }, {
      callback = update_jj_branch,
    })
    update_jj_branch()

    local statusline = require 'mini.statusline'
    statusline.setup {
      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
          local git         = statusline.section_git { trunc_width = 75 }
          local diff        = statusline.section_diff { trunc_width = 75 }
          local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
          local lsp         = statusline.section_lsp { trunc_width = 75 }
          local filename    = statusline.section_filename { trunc_width = 140 }
          local fileinfo    = statusline.section_fileinfo { trunc_width = 120 }
          local location    = statusline.section_location { trunc_width = 75 }

          return statusline.combine_groups {
            { hl = mode_hl,                  strings = { mode } },
            { hl = 'MiniStatuslineDevinfo',  strings = { jj_branch_cache, git, diff, diagnostics } },
            '%<',
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=',
            { hl = 'MiniStatuslineFileinfo', strings = { lsp, fileinfo } },
            { hl = mode_hl,                  strings = { location } },
          }
        end,
      },
    }

    require('mini.tabline').setup()

    require('mini.jump2d').setup { mappings = { start_jumping = 's' } }

    require('mini.indentscope').setup()

    -- J/K move selection up/down (replaces manual remaps in keymaps.lua).
    -- < and > indent but keep the visual selection (unlike bare < / >).
    -- Normal-mode line movement disabled: J is join lines, M-hjkl is tmux pane nav.
    require('mini.move').setup {
      mappings = {
        left       = '<',
        right      = '>',
        down       = 'J',
        up         = 'K',
        line_left  = '',
        line_right = '',
        line_down  = '',
        line_up    = '',
      },
    }

    require('mini.bufremove').setup()
    vim.keymap.set('n', '<leader>bd', MiniBufremove.delete, { desc = 'Delete Buffer' })

    require('mini.trailspace').setup()
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function() MiniTrailspace.trim() end,
    })

    require('mini.align').setup()

    require('mini.visits').setup()
    vim.keymap.set('n', '<leader>fv', function()
      local fzf = require 'fzf-lua'
      local entries = vim.tbl_map(function(path)
        local icon, hl = MiniIcons.get('file', path)
        return fzf.utils.ansi_from_hl(hl, icon) .. ' ' .. path
      end, MiniVisits.list_paths())
      fzf.fzf_exec(entries, {
        prompt = 'Visits> ',
        cwd = vim.fn.getcwd(),
        actions = {
          ['default'] = function(selected)
            if not selected or #selected == 0 then return end
            -- fzf strips ANSI on output; icon is one non-space glyph
            local path = selected[1]:match('^%S+ (.+)$')
            if path then vim.cmd('edit ' .. vim.fn.fnameescape(path)) end
          end,
        },
      })
    end, { desc = 'Search Visits' })
  end,
}
