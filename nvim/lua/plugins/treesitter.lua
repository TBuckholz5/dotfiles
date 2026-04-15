return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local languages = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'dart',
        'luadoc',
        'markdown',
        'json',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'rust',
        'python',
        'typescript',
        'javascript',
        'go',
      }

      -- Install any missing parsers
      local isnt_installed = function(lang)
        return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
      end
      local to_install = vim.tbl_filter(isnt_installed, languages)
      if #to_install > 0 then
        require('nvim-treesitter').install(to_install)
      end

      -- Collect filetypes for the language list
      local filetypes = {}
      for _, lang in ipairs(languages) do
        for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
          table.insert(filetypes, ft)
        end
      end

      -- Enable treesitter highlighting via FileType autocmd (Neovim 0.12 approach)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function(ev)
          vim.treesitter.start(ev.buf)
        end,
        desc = 'Start tree-sitter highlighting',
      })

      -- Enable for any buffers already open at startup
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local ft = vim.bo[buf].filetype
        if vim.list_contains(filetypes, ft) then
          pcall(vim.treesitter.start, buf)
        end
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
  },
}
