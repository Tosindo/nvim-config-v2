return {
  {
    dir = vim.fn.stdpath 'config' .. '/lua/tosindo/session.lua',
    name = 'tosindo-session',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('tosindo.session').setup {}
    end,
  },
}
