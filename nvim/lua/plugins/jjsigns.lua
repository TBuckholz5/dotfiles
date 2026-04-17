local function is_jj_repo()
  return vim.fn.finddir('.jj', vim.fn.getcwd() .. ';') ~= ''
end

return {
  'evanphx/jjsigns.nvim',
  cond = is_jj_repo,
  config = function()
    require('jjsigns').setup()

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'FocusGained' }, {
      callback = function()
        local ok, jjsigns = pcall(require, 'jjsigns')
        if ok and jjsigns.update then jjsigns.update() end
      end,
    })
  end,
}
