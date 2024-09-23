return {
  {
    'michaelPotter/snoozydev.nvim',
    config = function()
      require('snoozydev').setup {
        enabled = true,
      }
    end,
  },
}
