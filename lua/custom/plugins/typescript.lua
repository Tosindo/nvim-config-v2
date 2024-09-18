return {
  -- {
  --   'pmizio/typescript-tools.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig', 'oleggulevskyy/better-ts-errors.nvim' },
  --   ft = {
  --     'javascript',
  --     'javascriptreact',
  --     'javascript.jsx',
  --     'typescript',
  --     'typescriptreact',
  --     'typescript.tsx',
  --   },
  --   config = function()
  --     local capabilities = vim.lsp.protocol.make_client_capabilities()
  --     capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
  --
  --     require('typescript-tools').setup {
  --       on_attach = function(_, bufnr)
  --         require('better-ts-errors').setup()
  --         vim.keymap.set('n', '<leader>lo', '<cmd>TSToolsOrganizeImports<cr>', { buffer = bufnr, desc = 'Organize Imports' })
  --         vim.keymap.set('n', '<leader>lO', '<cmd>TSToolsSortImports<cr>', { buffer = bufnr, desc = 'Sort Imports' })
  --         vim.keymap.set('n', '<leader>lu', '<cmd>TSToolsRemoveUnused<cr>', { buffer = bufnr, desc = 'Removed Unused' })
  --         vim.keymap.set('n', '<leader>lz', '<cmd>TSToolsGoToSourceDefinition<cr>', { buffer = bufnr, desc = 'Go To Source Definition' })
  --         vim.keymap.set('n', '<leader>lR', '<cmd>TSToolsRemoveUnusedImports<cr>', { buffer = bufnr, desc = 'Removed Unused Imports' })
  --         vim.keymap.set('n', '<leader>lF', '<cmd>TSToolsFixAll<cr>', { buffer = bufnr, desc = 'Fix All' })
  --         vim.keymap.set('n', '<leader>lA', '<cmd>TSToolsAddMissingImports<cr>', { buffer = bufnr, desc = 'Add Missing Imports' })
  --       end,
  --       capabilities = capabilities,
  --       settings = {
  --         tsserver_file_preferences = {
  --           includeInlayParameterNameHints = 'all',
  --           includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --           includeInlayFunctionParameterTypeHints = true,
  --           includeInlayVariableTypeHints = true,
  --           includeInlayVariableTypeHintsWhenTypeMatchesName = true,
  --           includeInlayPropertyDeclarationTypeHints = true,
  --           includeInlayFunctionLikeReturnTypeHints = true,
  --           includeInlayEnumMemberValueHints = true,
  --         },
  --         expose_as_code_action = 'all',
  --         complete_function_calls = true,
  --         tsserver_plugins = {
  --           '@styled/typescript-styled-plugin',
  --         },
  --       },
  --     }
  --   end,
  -- },
  {
    'yioneko/nvim-vtsls',
    lazy = true,
    event = 'BufReadPre',
    ft = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
  },
}
