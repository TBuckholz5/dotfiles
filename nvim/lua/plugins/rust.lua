return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy
  keys = {
    {
      '<leader>ca',
      function()
        vim.cmd.RustLsp 'codeAction'
      end,
      mode = '',
      desc = 'Rust: [C]ode [A]ction',
    },
    {
      '<leader>ch',
      function()
        vim.cmd.RustLsp { 'hover', 'actions' }
      end,
      mode = '',
      desc = 'Rust: [C]ode [H]over',
    },
  },
}
