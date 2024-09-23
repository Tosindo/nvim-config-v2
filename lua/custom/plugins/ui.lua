return {
  {
    'j-hui/fidget.nvim',
    opts = {
      progress = {
        ignore_empty_message = true,
        display = {
          render_limit = 5,
        },
      },

      notification = {
        override_vim_notify = false,
      },
    },
  },
  -- lazy.nvim
  {
    'rcarriga/nvim-notify',
    opts = {
      render = 'compact',
      timeout = 2000,
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      hover = {
        enable = true,
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
          luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
          throttle = 50, -- Debounce lsp signature help request by 50ms
        },
        view = nil, -- when nil, use defaults from documentation
        opts = {}, -- merged with defaults from documentation
      },
      presets = {
        command_palette = true,
        -- long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
        cmdline_output_to_split = true,
      },
      popupmenu = {
        enabled = true,
        backend = 'nui',
      },
      views = {
        cmdline_popup = {
          border = {
            style = 'none',
            padding = { 1, 2 },
          },
          filter_options = {},
          win_options = {
            winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
          },
        },
        popupmenu = {
          relative = 'editor',
          border = {
            style = 'none',
            padding = { 1, 2 },
          },
          win_options = {
            winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
          },
        },
        cmdline_output = {
          buf_options = {
            filetype = 'noice_cmdline_output',
          },
        },
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },

    config = function(_, opts)
      require('noice').setup(opts)
      require('telescope').load_extension 'noice'
    end,
  },
  {
    dir = '~/esque.nvim/',
    name = 'esque-nvim',
    dev = true,
    dependencies = {
      'CWood-sdf/banana.nvim',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('esque').setup {
        splits = {
          {
            side = 'left',
            name = 'Sidebar',
            groups = {
              {
                name = 'Tree',
                icon = '󰙅 ',
                kbd = 'f',
                windows = {
                  {},
                },
              },
            },
          },
        },
      }
    end,
  },
}
