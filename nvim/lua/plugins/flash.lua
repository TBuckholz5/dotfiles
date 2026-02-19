return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    },
}
