return {
  'ibhagwan/fzf-lua',
  lazy = false,
  config = function()
    require('fzf-lua').setup {
      fzf_colors = true,
      fzf_opts = {
        ['--cycle'] = true,
        ['--ansi'] = true,
        ['--height'] = '100%',
        ['--highlight-line'] = true,
      },
      winopts = {
        height = 0.90,
        width = 0.80,
        preview = {
          layout = 'vertical',
        },
      },
      defaults = {
        -- show greyed-out directory before filename
        formatter = 'path.dirname_first',
      },
      keymap = {
        fzf = {
          ['ctrl-k'] = 'up',
          ['ctrl-j'] = 'down',
          ['ctrl-b'] = 'preview-page-up',
          ['ctrl-f'] = 'preview-page-down',
          ['ctrl-u'] = 'half-page-up',
          ['ctrl-d'] = 'half-page-down',
          ['alt-a'] = 'toggle-all',
          ['alt-g'] = 'first',
          ['alt-G'] = 'last',
          ['ctrl-c'] = 'abort',
        },
      },
    }
    require('fzf-lua').register_ui_select()
  end,
  keys = {
    { '<leader>ff', ':FzfLua files<CR>', desc = 'Search Files' },
    { '<leader>fb', ':FzfLua buffers<CR>', desc = 'Search Buffers' },
    { '<leader>/', ':FzfLua blines<CR>', desc = 'Fuzzy Search Current Buffer' },
    { '<leader>f/', ':FzfLua live_grep_native<CR>', desc = 'Search Live Grep' },
    { '<leader>fr', ':FzfLua resume<CR>', desc = 'Search Resume' },
    { '<leader>fd', ':FzfLua diagnostics_workspace<CR>', desc = 'Search Diagnostics' },
    { '<leader>fs', ':FzfLua lsp_document_symbols<CR>', desc = 'Search Document Symbols' },
    { '<leader>fw', ':FzfLua grep_cword<CR>', desc = 'Search Current Word' },
    { '<leader>fk', ':FzfLua keymaps<CR>', desc = 'Search Keymaps' },
    { '<leader>fu', ':FzfLua undotree<CR>', desc = 'Search undotree' },
    {
      '<leader>js',
      function()
        local fzf = require 'fzf-lua'
        local root = vim.trim(vim.fn.system 'jj root 2>/dev/null')
        if root == '' then
          vim.notify('Not in a jj repo', vim.log.levels.WARN)
          return
        end
        local lines = vim.fn.systemlist 'jj status --no-pager 2>/dev/null'
        local entries, paths = {}, {}
        local status_hl = { M = 'DiagnosticWarn', A = 'DiagnosticOk', D = 'DiagnosticError', R = 'DiagnosticInfo' }
        for _, line in ipairs(lines) do
          local st, path = line:match '^([MADR]) (.+)$'
          if st and path then
            local display = path:match '{.+ => (.+)}' or path
            local icon, icon_hl = MiniIcons.get('file', display)
            local entry = fzf.utils.ansi_from_hl(status_hl[st] or 'Normal', st)
              .. ' ' .. fzf.utils.ansi_from_hl(icon_hl, icon)
              .. ' ' .. display
            table.insert(entries, entry)
            table.insert(paths, root .. '/' .. display)
          end
        end
        if #entries == 0 then
          vim.notify('No jj changes', vim.log.levels.INFO)
          return
        end
        fzf.fzf_exec(entries, {
          prompt = 'JJ Status> ',
          actions = {
            ['default'] = function(selected)
              if not selected or #selected == 0 then return end
              -- fzf strips ANSI; entry format is: "S icon path"
              local path = selected[1]:match '^%S+ %S+ (.+)$'
              if path then vim.cmd('edit ' .. vim.fn.fnameescape(root .. '/' .. path)) end
            end,
          },
        })
      end,
      desc = 'JJ Status',
    },
  },
}
