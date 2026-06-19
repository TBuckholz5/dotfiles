return { -- Linting
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      markdown = { 'markdownlint' },
      javascript = { 'eslint' },
      typescript = { 'eslint' },
      python = { 'pylint' },
      lua = { 'luacheck' },
      go = { 'golangcilint' },
      protobuf = { 'buf' },
      rust = { 'clippy' },
    }
    require('lint').linters.golangcilint = vim.tbl_deep_extend('force', require('lint').linters.golangcilint, {
      args = vim.list_extend(
        vim.deepcopy(require('lint').linters.golangcilint.args),
        { '--build-tags', 'integration' }
      ),
    })

    -- Add 'vim' to luacheck's recognized globals while preserving the
    -- built-in parser/stdin/args (overwriting the whole table drops the
    -- parser, which crashes nvim-lint).
    require('lint').linters.luacheck = vim.tbl_deep_extend('force', require('lint').linters.luacheck, {
      args = vim.list_extend(
        { '--globals', 'vim' },
        vim.deepcopy(require('lint').linters.luacheck.args or {})
      ),
    })

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Only run the linter in buffers that you can modify in order to
        -- avoid superfluous noise, notably within the handy LSP pop-ups that
        -- describe the hovered symbol using Markdown.
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
        end
      end,
    })
  end,
}
