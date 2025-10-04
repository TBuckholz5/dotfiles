return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('fzf-lua').setup {
      keymap = {
        fzf = {
          ['ctrl-z'] = 'abort',
          ['ctrl-u'] = 'unix-line-discard',
          ['ctrl-f'] = 'half-page-down',
          ['ctrl-b'] = 'half-page-up',
          ['ctrl-a'] = 'beginning-of-line',
          ['ctrl-e'] = 'end-of-line',
          ['alt-a'] = 'toggle-all',
          ['ctrl-g'] = 'first',
          ['ctrl-G'] = 'last',
        },
      },
      actions = {
        files = {
          ['ctrl-q'] = FzfLua.actions.file_sel_to_qf,
          ['enter'] = FzfLua.actions.file_switch_or_edit,
          ['ctrl-x'] = FzfLua.actions.file_split,
          ['ctrl-v'] = FzfLua.actions.file_vsplit,
        },
      },
    }
  end,
  keys = {
    { '<leader>sf', ':FzfLua files<CR>', desc = '[S]earch [F]iles' },
    { '<leader>sb', ':FzfLua buffers<CR>', desc = '[S]earch [B]uffers' },
    { '<leader>/', ':FzfLua blines<CR>', desc = 'Fuzzy Search Current Buffer' },
    { '<leader>s/', ':FzfLua live_grep_native<CR>', desc = '[S]earch [L]ive Grep' },
    { '<leader>sr', ':FzfLua resume<CR>', desc = '[S]earch [R]esume' },
    { '<leader>sd', ':FzfLua diagnostics_workspace<CR>', desc = '[S]earch [D]iagnostics' },
    { '<leader>sw', ':FzfLua grep_cword<CR>', desc = '[S]earch [C]urrent [W]ord' },
    { '<leader>sk', ':FzfLua keymaps<CR>', desc = '[S]earch [K]eymaps' },
  },
}
