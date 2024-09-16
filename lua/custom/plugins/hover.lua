return {
  {
    'lewis6991/hover.nvim',
    config = function()
      local hover = require 'hover'
      hover.setup {
        init = function()
          require 'hover.providers.lsp'
          require 'hover.providers.gh'
          require 'hover.providers.gh_user'
          -- require('hover.providers.jira')
          -- require('hover.providers.dap')
          require 'hover.providers.fold_preview'
          require 'hover.providers.diagnostic'
          require 'hover.providers.man'
          require 'hover.providers.dictionary'
        end,
        preview_opts = {
          border = 'single',
        },
      }

      vim.keymap.set('n', 'K', require('hover').hover, { desc = 'hover.nvim' })
      vim.keymap.set('n', 'gK', require('hover').hover_select, { desc = 'hover.nvim (select)' })
    end,
  },
}
