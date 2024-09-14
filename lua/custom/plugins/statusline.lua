return {
  -- look into https://github.com/OXY2DEV/bars-N-lines.nvim
  -- seems like an interesting and beautiful implementation
  {
    dir = vim.fn.stdpath 'config' .. '/lua/tosindo/statusline',
    name = 'tosindo-statusline',
    config = function()
      require('tosindo.statusline').setup()
    end,
  },
}
