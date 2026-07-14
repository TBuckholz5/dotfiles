return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,

  opts = {
    terminal = {
      enabled = true,
      win = {
        style = 'terminal',
        position = 'float',
        relative = 'editor',
        border = 'rounded',
      },
    },
    lazygit = { enabled = true },
  },

  keys = {
    {
      '<leader>tt',
      function()
        Snacks.terminal.toggle()
      end,
      mode = { 'n', 't' },
      desc = '[T]oggle [T]erminal',
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>jj',
      function()
        Snacks.terminal.toggle 'jjui'
      end,
      mode = { 'n' },
      desc = 'jjui',
    },
    {
      '<leader>jb',
      function()
        local file = vim.fn.expand '%:p'
        if file == '' then
          vim.notify('No file in current buffer', vim.log.levels.WARN)
          return
        end
        local root_result = vim.system({ 'jj', 'root' }, { text = true }):wait()
        if root_result.code ~= 0 then
          vim.notify('Not in a jj repo', vim.log.levels.WARN)
          return
        end
        local root = vim.trim(root_result.stdout)
        local rel = file:sub(#root + 2)
        local source_win = vim.api.nvim_get_current_win()
        local source_line = vim.fn.line '.'

        local result = vim.system({ 'jj', 'file', 'annotate', rel }, { cwd = root, text = true }):wait()
        if result.code ~= 0 then
          vim.notify('jj annotate: ' .. vim.trim(result.stderr or ''), vim.log.levels.ERROR)
          return
        end

        -- parse annotate: "<hash> <author> <date> <time>    <lnum>: <content>"
        local raw_lines = vim.split(result.stdout, '\n', { trimempty = true })
        local parsed = {}
        local line_hashes = {}
        local unique_hashes, seen = {}, {}
        for _, raw in ipairs(raw_lines) do
          local hash, author, date = raw:match '^(%S+)%s+(%S+)%s+(%d%d%d%d%-%d%d%-%d%d)'
          table.insert(parsed, { hash = hash, author = author or '', date = date or '' })
          table.insert(line_hashes, hash)
          if hash and not seen[hash] then
            seen[hash] = true
            table.insert(unique_hashes, hash)
          end
        end

        -- fetch summaries for all unique change IDs in one jj log call
        local hash_to_summary = {}
        if #unique_hashes > 0 then
          local parts = vim.tbl_map(function(h) return 'latest(change_id(' .. h .. '))' end, unique_hashes)
          local log = vim.system({
            'jj', 'log', '--no-graph',
            '-T', 'change_id.short(8) ++ "\\t" ++ description.first_line() ++ "\\n"',
            '-r', table.concat(parts, ' | '),
          }, { cwd = root, text = true }):wait()
          if log.code == 0 then
            for line in log.stdout:gmatch '[^\n]+' do
              local h, desc = line:match '^(%S+)\t(.*)$'
              if h then hash_to_summary[h] = desc end
            end
          end
        end

        -- build blame lines
        -- block line 1: "[ abc12345  Author Name      2025-01-22"
        -- block line 2: "  commit summary in dim italic"
        -- block lines 3+: ""
        local AUTHOR_W = 16
        -- column layout: "[ "(2) + hash(8) + "  "(2) + author(AUTHOR_W) + "  "(2) + date(10)
        local COL_HASH   = 2
        local COL_AUTHOR = COL_HASH + 8 + 2
        local COL_DATE   = COL_AUTHOR + AUTHOR_W + 2

        local blame_lines = {}
        local line_types  = {}  -- 'header' | 'summary' | 'blank'
        local prev_hash, lines_in_block = nil, 0

        for _, p in ipairs(parsed) do
          if p.hash then
            if p.hash ~= prev_hash then
              local auth = p.author:sub(1, AUTHOR_W)
              auth = auth .. string.rep(' ', AUTHOR_W - #auth)
              table.insert(blame_lines, '[ ' .. p.hash:sub(1, 8) .. '  ' .. auth .. '  ' .. p.date)
              table.insert(line_types, 'header')
              lines_in_block = 1
              prev_hash = p.hash
            elseif lines_in_block == 1 then
              local summary = hash_to_summary[p.hash:sub(1, 8)] or ''
              if #summary > 36 then summary = summary:sub(1, 33) .. '...' end
              table.insert(blame_lines, '  ' .. summary)
              table.insert(line_types, 'summary')
              lines_in_block = 2
            else
              table.insert(blame_lines, '')
              table.insert(line_types, 'blank')
              lines_in_block = lines_in_block + 1
            end
          else
            table.insert(blame_lines, '')
            table.insert(line_types, 'blank')
            lines_in_block = lines_in_block + 1
          end
        end

        vim.cmd 'leftabove vsplit'
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(0, buf)
        local blame_win = vim.api.nvim_get_current_win()

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, blame_lines)
        vim.bo[buf].modifiable = false
        vim.bo[buf].buftype = 'nofile'

        -- per-column highlights matching gitsigns style
        local ns = vim.api.nvim_create_namespace 'jjblame'
        for i, ltype in ipairs(line_types) do
          if ltype == 'header' then
            vim.api.nvim_buf_add_highlight(buf, ns, 'LineNr',   i-1, 0,        COL_HASH)
            vim.api.nvim_buf_add_highlight(buf, ns, '@number',  i-1, COL_HASH,  COL_HASH + 8)
            vim.api.nvim_buf_add_highlight(buf, ns, '@keyword', i-1, COL_DATE,  COL_DATE + 10)
          elseif ltype == 'summary' then
            vim.api.nvim_buf_add_highlight(buf, ns, 'Comment', i-1, 0, -1)
          end
        end

        vim.api.nvim_win_set_width(blame_win, math.floor(vim.o.columns * 0.20))
        vim.wo[blame_win].number         = false
        vim.wo[blame_win].relativenumber = false
        vim.wo[blame_win].signcolumn     = 'no'
        vim.wo[blame_win].winfixwidth    = true
        vim.wo[blame_win].wrap           = false

        vim.wo[blame_win].cursorbind  = true
        vim.wo[source_win].cursorbind = true
        vim.api.nvim_win_set_cursor(blame_win, { source_line, 0 })

        -- Enter: show commit in a float buffer
        vim.keymap.set('n', '<CR>', function()
          local lnum = vim.api.nvim_win_get_cursor(blame_win)[1]
          local hash = line_hashes[lnum]
          if not hash then return end
          vim.wo[blame_win].cursorbind  = false
          vim.wo[source_win].cursorbind = false
          local show = vim.system(
            { 'jj', 'show', '-r', 'latest(change_id(' .. hash .. '))' },
            { cwd = root, text = true }
          ):wait()
          if show.code ~= 0 then
            vim.wo[blame_win].cursorbind  = true
            vim.wo[source_win].cursorbind = true
            vim.notify('jj show: ' .. vim.trim(show.stderr or ''), vim.log.levels.ERROR)
            return
          end
          local slines = vim.split(show.stdout, '\n', { trimempty = true })
          local sbuf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(sbuf, 0, -1, false, slines)
          vim.bo[sbuf].modifiable = false
          vim.bo[sbuf].buftype = 'nofile'
          local w = math.floor(vim.o.columns * 0.8)
          local h = math.floor(vim.o.lines * 0.8)
          vim.api.nvim_open_win(sbuf, true, {
            relative = 'editor', border = 'rounded', style = 'minimal',
            width = w, height = h,
            row = math.floor((vim.o.lines - h) / 2),
            col = math.floor((vim.o.columns - w) / 2),
          })
          local function restore()
            if vim.api.nvim_win_is_valid(blame_win)  then vim.wo[blame_win].cursorbind  = true end
            if vim.api.nvim_win_is_valid(source_win) then vim.wo[source_win].cursorbind = true end
          end
          vim.keymap.set('n', 'q',     function() vim.api.nvim_buf_delete(sbuf, { force = true }); restore() end, { buffer = sbuf })
          vim.keymap.set('n', '<Esc>', function() vim.api.nvim_buf_delete(sbuf, { force = true }); restore() end, { buffer = sbuf })
          vim.api.nvim_create_autocmd('BufDelete', { buffer = sbuf, once = true, callback = restore })
        end, { buffer = buf, desc = 'Show commit' })

        local function close()
          if vim.api.nvim_win_is_valid(source_win) then
            vim.wo[source_win].cursorbind = false
          end
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
        vim.keymap.set('n', 'q', close, { buffer = buf })
        vim.api.nvim_create_autocmd('BufDelete', { buffer = buf, once = true, callback = close })
        vim.api.nvim_create_autocmd('WinClosed', {
          pattern = tostring(blame_win),
          once = true,
          callback = function()
            if vim.api.nvim_win_is_valid(source_win) then
              vim.wo[source_win].cursorbind = false
            end
          end,
        })
      end,
      mode = { 'n' },
      desc = 'JJ Blame',
    },
  },
}
