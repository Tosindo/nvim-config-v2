return {
  -- look into https://github.com/OXY2DEV/bars-N-lines.nvim
  -- seems like an interesting and beautiful implementation
  -- {
  --   dir = vim.fn.stdpath 'config' .. '/lua/tosindo/statusline',
  --   name = 'tosindo-statusline',
  --   config = function()
  --     require('tosindo.statusline').setup()
  --   end,
  -- },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'jellybeans',
          globalstatus = false,

          disabled_filetypes = {
            'edgy',
            'Trouble',
            'neo-tree',
            'fidget',
          },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },

          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },
}
