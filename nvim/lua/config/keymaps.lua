vim.keymap.set('n', '<leader>dc', function()
  local diag = vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })[1]
  if diag then
    vim.fn.setreg('+', diag.message)
  end
end, { desc = 'Copy current [D]iagnostic [C]ontent to clipboard' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<Leader>dd', function()
  vim.diagnostic.open_float(0, { scope = 'line' })
end, { desc = 'Open/Enter Diagnostic Float' })

-- Terminal
-- vim.keymap.set('n', '<leader>tt', '<C-w>w', { desc = '[T]oggle [T]erminal Focus' })
-- vim.keymap.set('t', '<leader>tt', '<C-\\><C-N><C-w>w', { desc = '[T]oggle [T]erminal Focus' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-N>', { desc = 'Leave Terminal Mode' })
vim.keymap.set('n', '<leader>tn', '<cmd>sp | term<CR>', { desc = '[N]ew [T]erminal' })
vim.keymap.set('t', '<leader>td', '<C-d>', { desc = '[D]elete [T]erminal' })
vim.keymap.set('n', '<leader>tj', ':resize -10<CR>', { desc = 'Lower [T]erminal split height' })
vim.keymap.set('n', '<leader>tk', ':resize +10<CR>', { desc = 'Raise [T]erminal split height' })

-- Tabs
vim.keymap.set('n', '<leader>cc', ':tabnew<CR>:tcd ', { desc = 'New Tab' })
vim.keymap.set('n', '<leader>cd', ':tabc<CR>', { desc = 'Delete Tab' })
vim.keymap.set('n', '<C-1>', '1gt', { desc = 'Go to tab 1', noremap = true, silent = true })
vim.keymap.set('n', '<C-2>', '2gt', { desc = 'Go to tab 2', noremap = true, silent = true })
vim.keymap.set('n', '<C-3>', '3gt', { desc = 'Go to tab 3', noremap = true, silent = true })
vim.keymap.set('n', '<C-4>', '4gt', { desc = 'Go to tab 4', noremap = true, silent = true })

-- Folding
vim.keymap.set('n', '<leader>z', 'za', { desc = 'Toggle fold under cursor' })

-- General
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('x', '<leader>p', [["_dP]])

vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

vim.keymap.set('n', 'Q', '<nop>')

vim.keymap.set('i', '<C-S-n>', '<C-p>', { desc = 'Previous completion' })

vim.keymap.set('n', '<leader>lt', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle diagnostics' })
