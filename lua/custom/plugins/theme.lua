return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'rebelot/kanagawa.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    require('kanagawa').setup {
      compile = true,
      undercurl = true,
      dimInactive = true,
      terminalColors = true,
      theme = 'wave',

      overrides = function(colors)
        local theme = colors.theme

        return {
          DiagnosticDeprecated = {
            fg = theme.diag.warning,
            strikethrough = true,
          },
        }
      end,
    }

    -- Load the colorscheme here.
    vim.cmd.colorscheme 'kanagawa'

    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
  end,
}
