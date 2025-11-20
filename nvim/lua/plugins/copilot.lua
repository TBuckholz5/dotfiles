return {
  {
    'github/copilot.vim',
  },
  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    build = 'npm install -g mcp-hub@latest', -- Installs `mcp-hub` node binary globally
    config = function()
      require('mcphub').setup()
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
      { 'nvim-lua/plenary.nvim' },
      { 'ravitemer/mcphub.nvim' },
    },
    opts = {
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
      strategies = {
        chat = { adapter = 'copilot' },
        inline = { adapter = 'copilot' },
      },
      opts = {
        log_level = 'DEBUG',
      },
    },
    keys = {
      { '<leader>en', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Code Companion Chat' },
      { '<leader>ei', ':CodeCompanion', desc = 'Code Companion Inline' },
      { '<leader>ee', '<cmd>CodeCompanionActions<cr>', desc = 'Code Companion Actions' },
    },
  },
}
