return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local jj_branch_cache = ''

    local function update_jj_branch()
      vim.fn.jobstart({
        'jj',
        'log',
        '--no-pager',
        '-r',
        '::@ & bookmarks()',
        '--no-graph',
        '-T',
        'if(self.bookmarks(), self.bookmarks() ++ " ")',
        '-n',
        '1',
      }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          local result = table.concat(data or {}, ''):gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
          if result ~= '' then
            jj_branch_cache = 'jj:' .. result
          else
            jj_branch_cache = ''
          end
          vim.cmd 'redrawstatus'
        end,
        on_stderr = function() end,
        on_exit = function(_, code)
          if code ~= 0 then
            jj_branch_cache = ''
          end
        end,
      })
    end

    local function jj_branch()
      return jj_branch_cache
    end

    -- Update on events
    vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'DirChanged' }, {
      callback = update_jj_branch,
    })

    -- Initial update
    update_jj_branch()
    require('lualine').setup {
      sections = {
        lualine_b = {
          jj_branch,
          'branch',
          'diff',
          'diagnostics',
        },
      },
      options = {
        theme = 'auto',
        icons_enabled = vim.g.have_nerd_font,
      },
      tabline = {
        lualine_a = {
          {
            'tabs',
            mode = 2,
          },
        },
      },
    }
  end,
}
