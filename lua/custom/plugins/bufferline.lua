return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local Offset = require 'bufferline.offset'
      if not Offset.edgy then
        local get = Offset.get
        Offset.get = function()
          if package.loaded.edgy then
            local layout = require('edgy.config').layout
            local ret = { left = '', left_size = 0, right = '', right_size = 0 }
            for _, pos in ipairs { 'left', 'right' } do
              local sb = layout[pos]
              if sb and #sb.wins > 0 then
                local title = ' Sidebar' .. string.rep(' ', sb.bounds.width - 8)
                ret[pos] = '%#EdgyTitle#' .. title .. '%*' .. '%#WinSeparator#│%*'
                ret[pos .. '_size'] = sb.bounds.width
              end
            end
            ret.total_size = ret.left_size + ret.right_size
            if ret.total_size > 0 then
              return ret
            end
          end
          return get()
        end
        Offset.edgy = true
      end

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
