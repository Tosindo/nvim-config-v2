return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local bufferline = require 'bufferline'

      bufferline.setup {
        options = {
          mode = 'tabs',
          style_preset = bufferline.style_preset.default,
          themable = true,
          diagnostics = 'nvim_lsp',
          offsets = {
            {
              filetype = 'neo-tree',
              text = 'File Explorer',
              text_align = 'left',
              separator = true,
            },
          },
          color_icons = true,
          separator_style = 'tiny',
        },
      }
    end,
  },
}
