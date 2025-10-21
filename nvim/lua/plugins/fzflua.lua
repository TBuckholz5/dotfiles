return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('fzf-lua').setup {
      fzf_colors = true,
      fzf_opts = {
        ['--no-scrollbar'] = false,
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
  end,
  keys = {
    { '<leader>ff', ':FzfLua files<CR>', desc = '[S]earch [F]iles' },
    { '<leader>fb', ':FzfLua buffers<CR>', desc = '[S]earch [B]uffers' },
    { '<leader>/', ':FzfLua blines<CR>', desc = 'Fuzzy Search Current Buffer' },
    { '<leader>f/', ':FzfLua live_grep_native<CR>', desc = '[S]earch [L]ive Grep' },
    { '<leader>fr', ':FzfLua resume<CR>', desc = '[S]earch [R]esume' },
    { '<leader>fd', ':FzfLua diagnostics_workspace<CR>', desc = '[S]earch [D]iagnostics' },
    { '<leader>fw', ':FzfLua grep_cword<CR>', desc = '[S]earch [C]urrent [W]ord' },
    { '<leader>fk', ':FzfLua keymaps<CR>', desc = '[S]earch [K]eymaps' },
  },
}
