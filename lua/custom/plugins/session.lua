return {
  {
    dir = vim.fn.stdpath 'config' .. '/lua/tosindo/session.lua',
    name = 'tosindo-session',
    config = function()
      require('tosindo.session').setup()
    end,
  },
}
