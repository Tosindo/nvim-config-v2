return {
  {
    'mistweaverco/kulala.nvim',
    lazy = true,
    ft = {
      'http',
    },
    opts = {
      default_view = 'headers_body',
      winbar = true,
    },
    config = function(_, opts)
      require('kulala').setup(opts)
    end,
  },
}
