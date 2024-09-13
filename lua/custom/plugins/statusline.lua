return {
  {
    dir = vim.fn.stdpath 'config' .. '/lua/tosindo/statusline.lua',
    name = 'tosindo-statusline',
    config = function()
      require('tosindo.statusline').setup()
    end,
  },
}
