return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require('tokyonight').setup {
        on_highlights = function(hl, c)
          hl.DiagnosticDeprecated = { strikethrough = true }
          hl.StatusLineAccent = { bg = c.blue, fg = c.bg }
          hl.StatusLineInsertAccent = { bg = c.green, fg = c.bg }
          hl.StatusLineVisualAccent = { bg = c.purple, fg = c.bg }
          hl.StatusLineReplaceAccent = { bg = c.red, fg = c.bg }
          hl.StatusLineCmdLineAccent = { bg = c.bg, fg = c.blue }
          hl.StatusLineTerminalAccent = { bg = c.yellow, fg = c.bg }
        end,
      }

      -- Load the colorscheme here.
      vim.cmd.colorscheme 'tokyonight'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    'rktjmp/lush.nvim',
  },
}
