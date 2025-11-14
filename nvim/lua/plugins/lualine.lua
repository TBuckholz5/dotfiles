return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function is_jj_repo(path)
      local uv = vim.loop
      path = path or uv.cwd()
      while path do
        local jj_dir = path .. '/.jj'
        local stat = uv.fs_stat(jj_dir)
        if stat and stat.type == 'directory' then
          return true
        end
        local parent = path:match '(.+)/[^/]+$'
        if parent == path then
          break
        end
        path = parent
      end
      return false
    end
    local function jj_branch()
      if not is_jj_repo() then
        return ''
      end

      for i = 0, 5 do
        local rev = '@'
        rev = rev .. string.rep('-', i)
        local cmd = string.format("jj log --no-pager -r '%s' --no-graph --template 'self.bookmarks()'", rev)
        local handle = io.popen(cmd)
        if not handle then
          return ''
        end
        local result = handle:read '*a'
        handle:close()
        result = result:gsub('%s+', '')
        if result ~= '' then
          return 'jj:' .. result
        end
      end
      return ''
    end
    require('lualine').setup {
      sections = {
        lualine_b = {
          jj_branch,
          'branch',
          'diff',
          'diagnostics',
        },
      },
      options = {
        theme = 'auto',
        icons_enabled = vim.g.have_nerd_font,
      },
      tabline = {
        lualine_a = {
          {
            'tabs',
            mode = 2,
          },
        },
      },
    }
  end,
}
