return {
  {
    'rktjmp/lush.nvim',
  },
  {
    dir = vim.fn.stdpath 'config' .. '/lua/tosindo/makeup',
    lazy = false,
    event = 'UIEnter',
    config = function()
      vim.cmd.colorscheme 'makeup'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
