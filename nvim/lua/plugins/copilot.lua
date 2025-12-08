return {
  {
    'github/copilot.vim',
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    keys = {
      { '<leader>en', '<cmd>CopilotChatOpen<cr>', desc = 'Open Copilot Chat' },
    },
  },
}
