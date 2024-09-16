return {
  -- {
  --   dir = vim.fn.stdpath 'config' .. '/lua/tosindo/fluent',
  --   name = 'tosindo-fluent',
  --   config = function()
  --     require('tosindo.fluent').setup()
  --   end,
  -- },
  {
    'zbirenbaum/copilot.lua',
    lazy = true,
    event = 'InsertEnter',
    cmd = 'Copilot',
    config = function()
      require('copilot').setup {
        -- handled by copilot-cmp
        suggestion = { enabled = false },
        -- handled by copilot-cmp
        panel = { enabled = false },
      }
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
      {
        'stevearc/dressing.nvim', -- Optional: Improves the default Neovim UI
        opts = {},
      },
      'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
    },
    config = function()
      require('codecompanion').setup {
        adapters = {
          anthropic = function()
            return require('codecompanion.adapters').extend('anthropic', {
              env = {
                api_key = 'cmd:op read op://personal/Anthropic/credential --no-newline',
              },
            })
          end,
        },
        strategies = {
          chat = {
            adapter = 'anthropic',
          },
          inline = {
            adapter = 'copilot',
          },
          agent = {
            adapter = 'anthropic',
          },
        },
      }

      vim.api.nvim_set_keymap('n', ';ca', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('v', ';ca', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', ';cb', '<cmd>CodeCompanionToggle<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('v', ';cb', '<cmd>CodeCompanionToggle<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('v', 'ga', '<cmd>CodeCompanionAdd<cr>', { noremap = true, silent = true })

      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd [[cab cc CodeCompanion]]
    end,
  },
}
