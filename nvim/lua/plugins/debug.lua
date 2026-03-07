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

    dap.adapters.go_remote = {
      type = 'server',
      host = '127.0.0.1',
      port = 2345,
    }

    table.insert(dap.configurations.go, {
      type = 'go_remote',
      request = 'attach',
      name = 'Attach remote',
      mode = 'remote',
      substitutePath = { {
        from = '/Users/tbuckholz/bookshelf-app/server',
        to = '/app',
      } },
      connect = function()
        local host = vim.fn.input 'Host [127.0.0.1]: '
        host = host ~= '' and host or '127.0.0.1'
        local port = tonumber(vim.fn.input 'Port [2345]: ') or 2345
        return { host = host, port = port }
      end,
    })
  end,
}
