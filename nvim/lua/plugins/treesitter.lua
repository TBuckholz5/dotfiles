return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local ensure_installed = {
        'bash', 'c', 'diff', 'html', 'lua', 'dart', 'luadoc', 'markdown',
        'json', 'markdown_inline', 'query', 'vim', 'vimdoc', 'rust', 'python',
        'typescript', 'javascript', 'go',
      }

      -- Install missing parsers on startup without blocking
      vim.schedule(function()
        local config = require('nvim-treesitter.config')
        local install = require('nvim-treesitter.install')
        local installed = config.get_installed()
        local installed_set = {}
        for _, lang in ipairs(installed) do
          installed_set[lang] = true
        end
        local missing = vim.tbl_filter(function(l)
          return not installed_set[l]
        end, ensure_installed)
        if #missing > 0 then
          install.install(missing)
        end
      end)

      -- Highlighting and indent via FileType autocmd (new API)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(ev)
          local ft = vim.bo[ev.buf].filetype
          if not vim.treesitter.query.get(ft, 'highlights') then return end
          local ok = pcall(vim.treesitter.start, ev.buf)
          if ok and ft ~= 'ruby' then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
  },
}
