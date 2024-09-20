return {
  {
    'jackMort/pommodoro-clock.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    opts = {},
    config = function(_, opts)
      local pommodoro = require 'pommodoro-clock'

      pommodoro.setup(opts)

      vim.keymap.set('n', ';pw', function()
        pommodoro.start 'work'
      end, { desc = 'Start a work session' })

      vim.keymap.set('n', ';ps', function()
        pommodoro.start 'short_break'
      end, { desc = 'Start a short break' })

      vim.keymap.set('n', ';pl', function()
        pommodoro.start 'long_break'
      end, { desc = 'Start a long break' })

      vim.keymap.set('n', ';pp', function()
        pommodoro.toggle_pause()
      end, { desc = 'Toggle pause' })

      vim.keymap.set('n', ';pc', function()
        pommodoro.close()
      end, { desc = 'Stop the clock' })
    end,
  },
}
