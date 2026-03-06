return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-neotest/nvim-nio',
    'jay-babu/mason-nvim-dap.nvim',
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    {
      '<leader>bb',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'DAP: Toggle Breakpoint',
    },
    {
      '<leader>bc',
      function()
        require('dap').continue()
      end,
      desc = 'DAP: Continue',
    },
    {
      '<leader>bo',
      function()
        require('dap').step_over()
      end,
      desc = 'DAP: Step Over',
    },
    {
      '<leader>bi',
      function()
        require('dap').step_into()
      end,
      desc = 'DAP: Step Into',
    },
    {
      '<leader>bu',
      function()
        require('dap').step_out()
      end,
      desc = 'DAP: Step Out',
    },
    {
      '<leader>bt',
      function()
        require('dapui').toggle()
      end,
      desc = 'DAP: Toggle UI',
    },
    {
      '<leader>be',
      function()
        require('dap.ui.widgets').eval()
      end,
      desc = 'DAP: Eval',
    },
  },
  config = function()
    require('mason-nvim-dap').setup {
      ensure_installed = { 'delve', 'python' },
      automatic_installation = true,
      handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
      },
    }

    require('dap-python').setup 'uv'

    local dap = require 'dap'
    local dapui = require 'dapui'
    dapui.setup()
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end
  end,
}
