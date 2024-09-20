return {
  -- {
  --   'lucobellic/edgy-group.nvim',
  --   dependencies = { 'folke/edgy.nvim' },
  --   event = 'VeryLazy',
  --   keys = {
  --     {
  --       '<leader>el',
  --       function()
  --         require('edgy-group').open_group_offset('left', 1)
  --       end,
  --       desc = 'Edgy Group Next Left',
  --     },
  --     {
  --       '<leader>eh',
  --       function()
  --         require('edgy-group').open_group_offset('left', -1)
  --       end,
  --       desc = 'Edgy Group Prev Left',
  --     },
  --     {
  --       '<c-,>',
  --       function()
  --         require('edgy-group.stl').pick()
  --       end,
  --       desc = 'Edgy Group Pick',
  --     },
  --   },
  --   opts = {
  --     groups = {
  --       left = {
  --         { icon = '', titles = { 'Neo-Tree', 'Neo-Tree Git' } },
  --         -- { icon = '', titles = { 'LSP Doc Symbols' } },
  --       },
  --       bottom = {
  --         { icon = '', titles = { 'Console Output' } },
  --         { icon = '', titles = { 'Trouble' } },
  --         { icon = '', titles = { 'Help' } },
  --       },
  --     },
  --
  --     statusline = {
  --       -- suffix and prefix separators between icons
  --       separators = { ' ', ' ' },
  --       clickable = true, -- open group on click
  --       colored = true, -- enable highlight support
  --       colors = { -- highlight colors
  --         active = 'Normal', -- highlight color for open group
  --         inactive = 'Normal', -- highlight color for closed group
  --         pick_active = 'PmenuSel', -- highlight color for pick key for open group
  --         pick_inactive = 'PmenuSel', -- highlight color for pick key for closed group
  --         separator_active = 'Normal', -- highlight color for separator for open group
  --         separator_inactive = 'Normal', -- highlight color for separator for closed group
  --       },
  --       -- pick key position: left, right, left_separator, right_separator, icon
  --       -- left: before left separator
  --       -- right: after right separator
  --       -- left_separator, right_separator and icon: replace the corresponding element
  --       pick_key_pose = 'left',
  --       pick_function = nil, -- optional function to override default behavior
  --     },
  --   },
  -- },

  {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    opts = {
      -- edgebar animations
      animate = {
        enabled = true,
        fps = 100, -- frames per second
        cps = 120, -- cells per second
        on_begin = function()
          vim.g.minianimate_disable = true
        end,
        on_end = function()
          vim.g.minianimate_disable = false
        end,
        -- Spinner for pinned views that are loading.
        -- if you have noice.nvim installed, you can use any spinner from it, like:
        spinner = require('noice.util.spinners').spinners.circleFull,
      },

      options = {
        right = {
          size = 80,
        },
      },

      wo = {
        winbar = true,
      },

      bottom = {
        {
          title = 'Console Output',
          ft = 'noice_cmdline_output',
        },
        {
          title = 'Trouble',
          ft = 'trouble',
          filter = function(_, win)
            return vim.w[win].trouble.position == 'bottom'
          end,
        },
        {
          title = 'Help',
          ft = 'help',
          size = {
            height = 20,
          },
          filter = function(buf)
            return vim.bo[buf].buftype == 'help'
          end,
        },
      },
      left = {
        {
          title = 'Neo-Tree',
          ft = 'neo-tree',
          filter = function(buf)
            return vim.b[buf].neo_tree_source == 'filesystem'
          end,
          pinned = true,
          size = { height = 0.5 },
          open = 'Neotree reveal position=left filesystem',
        },
        {
          title = 'Neo-Tree Git',
          ft = 'neo-tree',
          filter = function(buf)
            return vim.b[buf].neo_tree_source == 'git_status'
          end,
          pinned = true,
          open = 'Neotree position=right git_status',
        },
        -- {
        --   title = 'LSP Doc Symbols',
        --   filter = function(_, win)
        --     return vim.w[win].trouble.position == 'left' and vim.w[win].trouble.mode == 'lsp_document_symbols'
        --   end,
        --   ft = 'trouble',
        --   open = 'Trouble lsp_document_symbols focus=false win.position=left',
        -- },
      },
      right = {
        {
          title = 'AI',
          ft = 'codecompanion',
          filter = function(buf)
            return vim.bo[buf].filetype == 'codecompanion'
          end,
          pinned = true,
        },
      },
    },
    keys = {
      {
        '<S-Tab>',
        function()
          local edgy = require 'edgy'

          -- currently on neo-tree we toggle the left edgy window
          if vim.bo.filetype == 'neo-tree' then
            edgy.close 'left'
          else
            edgy.open 'left'

            require('neo-tree.command').execute {
              action = 'focus',
              source = 'filesystem',
              position = 'left',
            }
          end
        end,
        desc = 'Toggle sidebar',
        silent = true,
      },
    },
  },
}
