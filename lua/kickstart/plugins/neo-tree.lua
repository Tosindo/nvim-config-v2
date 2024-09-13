-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<S-Tab>', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['<S-Tab>'] = 'close_window',
          ['<2-LeftMouse>'] = 'open_with_window_picker',
          ['<cr>'] = 'open_with_window_picker',
        },
      },
      filtered_items = {
        visible = true,
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
    },
    nesting_rules = {
      ['package.json'] = {
        pattern = '^package%.json$', -- <-- Lua pattern
        files = { 'package-lock.json', 'yarn*' }, -- <-- glob pattern
      },
      ['docker'] = {
        pattern = '^dockerfile$',
        ignore_case = true,
        files = { '.dockerignore', 'docker-compose.*', 'dockerfile*' },
      },
      ['env'] = {
        pattern = '^\\.env(\\..*)?$',
        ignore_case = true,
        files = {
          '.env',
          '.env.*',
        },
      },
    },
  },
}
